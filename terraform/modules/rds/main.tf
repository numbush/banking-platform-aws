resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "main" {
    name = "${var.project_name}-${var.environment}-${var.database_name}-subnet-group"
    subnet_ids = var.private_subnet_ids

    tags = merge(var.tags, {
        Name = "${var.project_name}-${var.environment}-${var.database_name}-subnet-group"
    })
}

resource "aws_security_group" "rds" {
    name = "${var.project_name}-${var.environment}-${var.database_name}-rds-security-group"
    description = "Security group for the RDS ${var.database_name}"
    vpc_id = var.vpc_id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = var.allowed_security_groups_ids
        description = "Allow inbound traffic from the allowed security groups"
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow outbound traffic to all IP addresses"
    }

    tags = merge(var.tags, {
        Name = "${var.project_name}-${var.environment}-${var.database_name}-rds-security-group"
    })
}

resource "aws_db_instance" "main" {
 identifier = "${var.project_name}-${var.environment}-${var.database_name}"
 engine = "postgres"
 instance_class = var.instance_class
 allocated_storage = var.allocated_storage
 storage_type = "gp3"
 storage_encrypted = true

 db_name = var.database_name
 username = var.master_username
 password = random_password.master.result

 db_subnet_group_name = aws_db_subnet_group.main.name
 vpc_security_group_ids = [aws_security_group.rds.id]

 multi_az = var.multi_az
 publicly_accessible = false
 deletion_protection = var.delete_protection
 skip_final_snapshot = var.environment == "dev" ? true : false
 final_snapshot_identifier = var.environment == "dev" ? null : "${var.project_name}-${var.environment}-${var.database_name}-final-snapshot"

 backup_retention_period = var.backup_retention_period
 backup_window = "03:00-04:00"
 maintenance_window = "mon:04:00-mon:05:00"

 enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

 tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-${var.database_name}"
 })
}


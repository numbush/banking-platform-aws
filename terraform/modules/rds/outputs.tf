output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.main.db_name
}

output "master_username" {
  description = "The username of the master user"
  value       = var.master_username
  sensitive   = true
}

output "master_password" {
  description = "The password of the master user"
  value       = random_password.master.result
  sensitive   = true
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.rds.id
}

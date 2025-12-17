# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnets_cidr  = var.public_subnet_cidrs
  private_subnets_cidr = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  region               = var.aws_region

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
module "iam" {
  source = "../../modules/iam"

  project_name      = var.project_name
  environment       = var.environment
  eks_cluster_name  = "${var.project_name}-${var.environment}-eks"

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# EKS Module
module "eks" {
  source = "../../modules/eks"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnets_ids
  public_subnet_ids       = module.vpc.public_subnets_ids
  cluster_version         = var.eks_cluster_version
  node_group_desired_size = var.eks_node_desired_size
  node_group_min_size     = var.eks_node_min_size
  node_group_max_size     = var.eks_node_max_size
  node_instance_types     = var.eks_node_instance_types
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  depends_on = [module.vpc]
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment = var.environment
  repository_names = ["accounts-services", "loans-services", "gateway-service", "cards-services"]
  
  scan_on_push = true
  
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

module "rds_accounts" {
  source = "../../modules/rds"
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_ids
  database_name = "accounts"
  master_username = "dbadmin"
  instance_class = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  multi_az = var.rds_multi_az
  delete_protection = var.rds_delete_protection
  allowed_security_groups_ids = [module.eks.cluster_security_group_id]
  tags = {
    Environment = var.environment
    Service     = "accounts"
    Terraform   = "true"
  }

  depends_on = [module.vpc , module.eks]
}

module "rds_cards" {
  source = "../../modules/rds"
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_ids
  database_name = "cards"
  master_username = "dbadmin"
  instance_class = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  multi_az = var.rds_multi_az
  delete_protection = var.rds_delete_protection
  allowed_security_groups_ids = [module.eks.cluster_security_group_id]
  tags = {
    Environment = var.environment
    Service     = "cards"
    Terraform   = "true"
  }

  depends_on = [module.vpc , module.eks]
}

module "rds_loans" {
  source = "../../modules/rds"
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_ids
  database_name = "loans"
  master_username = "dbadmin"
  instance_class = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  multi_az = var.rds_multi_az
  delete_protection = var.rds_delete_protection
  allowed_security_groups_ids = [module.eks.cluster_security_group_id]
  tags = {  
    Environment = var.environment
    Service     = "loans"
    Terraform   = "true"
  }

  depends_on = [module.vpc , module.eks]
}

module "secrets" {
  source = "../../modules/secretsmanager"
  project_name = var.project_name
  environment = var.environment

  secrets = {
    "accounts-db" = {
      description = "Secrets for the accounts database"
      secret_data = {
        host = module.rds_accounts.db_instance_address
        port = tostring(module.rds_accounts.db_instance_port)
        database = module.rds_accounts.db_name
        username = module.rds_accounts.master_username
        password = module.rds_accounts.master_password
      }
    }

    "cards-db" ={
    description = "Secrets for the cards database"
    secret_data = {
      host = module.rds_cards.db_instance_address
      port = tostring(module.rds_cards.db_instance_port)
      database = module.rds_cards.db_name
      username = module.rds_cards.master_username
      password = module.rds_cards.master_password
    }
  }

    "loans-db" = {
      description = "Secrets for the loans database"
      secret_data = {
        host = module.rds_loans.db_instance_address
        port = tostring(module.rds_loans.db_instance_port)
        database = module.rds_loans.db_name
        username = module.rds_loans.master_username
        password = module.rds_loans.master_password
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  depends_on = [module.rds_accounts, module.rds_cards, module.rds_loans]
}
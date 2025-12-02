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
  oidc_provider_arn = module.eks.oidc_provider_arn

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

 
}

# EKS Module
module "eks" {
  source = "../../modules/eks"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnets_ids
  public_subnet_ids          = module.vpc.public_subnets_ids
  cluster_version            = var.eks_cluster_version
  node_group_desired_size    = var.eks_node_desired_size
  node_group_min_size        = var.eks_node_min_size
  node_group_max_size        = var.eks_node_max_size
  node_instance_types        = var.eks_node_instance_types
  eks_cluster_role_arn       = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn    = module.iam.eks_node_group_role_arn

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  depends_on = [module.vpc]
}
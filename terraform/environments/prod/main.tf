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
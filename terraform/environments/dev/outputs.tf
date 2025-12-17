output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets_ids
}

output "nat_gateway_ips" {
  description = "NAT Gateway IPs"
  value       = module.vpc.nat_gateways_ips
}

output "availability_zones" {
  description = "Availability zones"
  value       = module.vpc.availability_zones
}

# EKS Outputs
output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster version"
  value       = module.eks.cluster_version
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

# ECR Outputs
output "ecr_repository_urls" {
  description = "ECR repository URLs"
  value       = module.ecr.repository_urls
}

# RDS Outputs
output "rds_accounts_endpoint" {
  description = "Accounts RDS endpoint"
  value       = module.rds_accounts.db_instance_endpoint
}

output "rds_cards_endpoint" {
  description = "Cards RDS endpoint"
  value       = module.rds_cards.db_instance_endpoint
}

output "rds_loans_endpoint" {
  description = "Loans RDS endpoint"
  value       = module.rds_loans.db_instance_endpoint
}

# Secrets Manager Outputs
output "secret_arns" {
  description = "Secret ARNs"
  value       = module.secrets.secret_arns
  sensitive   = true
}
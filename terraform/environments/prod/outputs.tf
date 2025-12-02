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
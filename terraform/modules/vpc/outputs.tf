output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.main.id
}

output "vpc_cidr_block" {
    description = "The CIDR block of the VPC"
    value = aws_vpc.main.cidr_block
}

output "public_subnets_ids" {
    description = "The IDs of the public subnets"
    value = aws_subnet.public[*].id
}

output "private_subnets_ids" {
    description = "The IDs of the private subnets"
    value = aws_subnet.private[*].id
}

output "nat_gateways_ips" {
    description = "The IDs of the NAT gateways"
    value = aws_nat_gateway.nat[*].id
}

output "public_route_table_id" {
    description = "The ID of the public route table"
    value = aws_route_table.public.id
}

output "private_route_tables_ids" {
    description = "The IDs of the private route tables"
    value = aws_route_table.private[*].id
}

output "availability_zones" {
    description = "The availability zones"
    value = var.availability_zones
}

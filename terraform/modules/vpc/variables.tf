variable "project_name" {
    description = "The name of the project"
    type = string
}

variable "environment" {
    description = "The environment"
    type = string
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type = string
}

variable "public_subnets_cidr" {
    description = "The CIDR blocks for the public subnets"
    type = list(string)
}

variable "private_subnets_cidr" {
    description = "The CIDR blocks for the private subnets"
    type = list(string)
}

variable "enable_nat_gateway" {
    description = "Whether to enable NAT gateway"
    type = bool
    default = true
}

variable "tags" {
    description = "The tags to apply to the resources"
    type = map(string)
    default = {}
}

variable "availability_zones" {
    description = "The availability zones"
    type = list(string)
}

variable "region" {
    description = "The region"
    type = string
}
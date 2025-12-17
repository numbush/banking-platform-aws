variable "project_name" {
    description = "The name of the project"
    type = string
}

variable "environment" {
    description = "The environment"
    type = string
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type = string
}

variable "private_subnet_ids" {
    description = "The IDs of the private subnets"
    type = list(string)
}

variable "database_name" {
    description = "The name of the database"
    type = string
}

variable "master_username" {
    description = "The username of the master user"
    type = string
    default = "dbadmin"
}

variable "engine_version" {
    description = "The version of the engine"
    type = string
    default = "15.4"
}

variable "instance_class" {
    description = "The class of the instance"
    type = string
    default = "db.t3.micro"
}

variable "allocated_storage" {
    description = "The allocated storage of the database"
    type = number
    default = 20
}

variable "multi_az" {
    description = "Whether to enable multi-az"
    type = bool
    default = false
}

variable "backup_retention_period" {
    description = "The backup retention period"
    type = number
    default = 7
}

variable "delete_protection" {
    description = "Whether to enable delete protection"
    type = bool
    default = false
}

variable "allowed_security_groups_ids" {
    description = "The IDs of the allowed security groups"
    type = list(string)
    default = []
}

variable "tags" {
    description = "The tags to apply to the resources"
    type = map(string)
    default = {}
}


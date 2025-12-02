/* terraform {
  backend "s3" {
    bucket         = "banking-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "banking-terraform-locks-prod"
  }
} */
/* terraform {
  backend "s3" {
    bucket         = "banking-terraform-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "banking-terraform-lock-dev"
  }
}
 */

provider "aws" {
  region = "us-east-1"
}

# Stores terraform.tfstate in aws
terraform {
  backend "s3" {
    bucket         = "terraform-state-atilaromero-terraform-examples"
    dynamodb_table = "terraform-locks"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
# Creates a S3 bucket and a DynamoDB with a LockID table
# These are requirements to use a remote tfstate
# bucket and dynamodb_table must match the same values above
module s3_backend {
    source         = "./s3_backend"
    bucket         = "terraform-state-atilaromero-terraform-examples"
    dynamodb_table = "terraform-locks"
}

# To use in free tier
# This module monitors the account costs.
# When it is greater than $0.01 per day, it sends an e-mail alert
module "budget" {
  source = "./budget"
  subscriber_email_addresses = ["atilaromero@gmail.com"]
}

# Creates a VPC using 2 zones. Each zone has 2 subnets, one public and one private.
module "vpc" {
  source = "./vpc"
  name  = "App"
  cidr_block = "10.0.0.0/16"
  region = "us-east-1"
  subnet_1 = {
    availability_zone = "us-east-1a"
    public_CIDR = "10.0.1.0/24"
    private_CIDR = "10.0.101.0/24"
  }
  subnet_2 = {
    availability_zone = "us-east-1b"
    public_CIDR = "10.0.2.0/24"
    private_CIDR = "10.0.102.0/24"
  }
}

module "dynamodb" {
  source = "./dynamodb"
  count = 0
}

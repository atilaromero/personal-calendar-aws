provider "aws" {
  region = "us-east-1"
}

# To use in free tier
# This module monitors the account costs.
# When it is greater than $0.01 per day, it sends an e-mail alert
module "zero_budget" {
  source = "./zero_budget"
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

# Creates a ECR repository
module "ecr" {
  source = "./ecr"
  repository = "calendar-lambda"
}

# Creates a IAM user for Github Actions
module "github_user" {
  source = "./github_user"
  user = "github"
  repository = module.ecr.repository
}

module "lambda" {
  image_uri = "269789260668.dkr.ecr.us-east-1.amazonaws.com/calendar-lambda:66a73090fb09c622b83f6532da5fe570f054d520"
  function_name = "calendar-lambda"
}

output "AWS_ACCESS_KEY_ID" {
  description = "Create this secret in Github to use with github Actions"
  value = module.github_user.AWS_ACCESS_KEY_ID
}

output "AWS_SECRET_ACCESS_KEY" {
  description = "Create this secret in Github to use with github Actions"
  value = module.github_user.AWS_SECRET_ACCESS_KEY
}
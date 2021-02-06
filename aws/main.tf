provider "aws" {
  region = "us-east-1"
}

module "budget" {
  # To use in free tier
  # This module monitors the account costs.
  # When it is greater than $0.01 per day, it sends an alert e-mail
  source = "./budget"
  subscriber_email_addresses = ["atilaromero@gmail.com"]
}

module "vpc" {
  # Creates a VPC using 2 zones. Each zone has 2 subnets, one public and one private.
  source = "./vpc"
}

module "dynamodb" {
  source = "./dynamodb"
  count = 0
}

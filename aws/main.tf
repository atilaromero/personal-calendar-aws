provider "aws" {
  region = "us-east-1"
}

module "budget" {
  source = "./budget"
  subscriber_email_addresses = ["atilaromero@gmail.com"]
}

module "dynamodb" {
  source = "./dynamodb"
  count = 0
}

module "vpc" {
  source = "./vpc"
  count = 1
}


# Stores terraform.tfstate in aws
terraform {
  backend "s3" {
    bucket         = "terraform-state-atilaromero-personal-calendar-aws"
    dynamodb_table = "terraform-locks"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

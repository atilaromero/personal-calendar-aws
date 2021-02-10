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
# Creates a S3 bucket and a DynamoDB with a LockID table
# These are requirements to use a remote tfstate
# bucket and dynamodb_table must match the same values above
module s3_backend {
    source         = "./s3_backend"
    bucket         = "terraform-state-atilaromero-personal-calendar-aws"
    dynamodb_table = "terraform-locks"
}


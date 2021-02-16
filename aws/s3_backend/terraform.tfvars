# Creates a S3 bucket and a DynamoDB with a LockID table
# These are requirements to use a remote tfstate
# bucket and dynamodb_table must match the variables used in ../remote_tfstate.tf
bucket         = "terraform-state-atilaromero-personal-calendar-aws"
dynamodb_table = "terraform-locks"
region         = "us-east-1"


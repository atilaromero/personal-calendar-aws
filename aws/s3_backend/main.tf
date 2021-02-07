variable bucket {
  type = string
  description = "unique bucket name, same as used in backend s3 'bucket' value"
}
variable dynamodb_table {
  type = string
  description = "lock table name, same as used in backend s3 'dynamodb_table' value"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = var.dynamodb_table
  billing_mode = "PROVISIONED"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

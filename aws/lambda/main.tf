variable "image_uri" {
  type = string
}

variable "function_name" {
  type = string
}

resource "aws_lambda_function" "test_lambda" {
  image_uri     = var.image_uri
  function_name = var.function_name
}
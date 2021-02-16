variable "repository" {
  type = string
}

resource "aws_ecr_repository" "repo" {
  name                 = var.repository
  image_tag_mutability = "MUTABLE"
}

output "repository" {
  value = var.repository
}
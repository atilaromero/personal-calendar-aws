resource "aws_ecr_repository" "repo" {
  name                 = "repo"
  image_tag_mutability = "MUTABLE"
}

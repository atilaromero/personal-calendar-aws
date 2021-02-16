variable "repository" {
  type = string
}

variable "user" {
  type = string
}

resource "aws_iam_user" "github" {
  name = var.user
}

data "aws_iam_policy_document" "ecr" {
  statement {
    actions   = ["*"]
    resources = ["arn:aws:ecr:*:*:repository/${var.repository}"]
  }

  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "github" {
  name = "ecr"
  user = aws_iam_user.github.name
  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}
output "AWS_ACCESS_KEY_ID" {
  value = aws_iam_access_key.github.id
}
output "AWS_SECRET_ACCESS_KEY" {
  value = aws_iam_access_key.github.secret
}

variable "repository" {
  default = "repo"
}

variable "user" {
  default = "github"
}

resource "aws_iam_user" "github" {
  name = var.user
}

data "aws_iam_user" "github" {
  user_name = aws_iam_user.github.name
}

output "AWS_ACCESS_KEY_ID" {
  value = data.aws_iam_user.github.user_id
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}
output "AWS_SECRET_ACCESS_KEY" {
  value = aws_iam_access_key.github.secret
}

data "aws_iam_policy_document" "ecr" {
  statement {
    actions   = ["ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:ListTagsForResource",
                "ecr:UploadLayerPart",
                "ecr:BatchDeleteImage",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:DeleteRepositoryPolicy",
                "ecr:BatchCheckLayerAvailability",
                "ecr:ReplicateImage",
                "ecr:GetLifecyclePolicy",
                "ecr:PutLifecyclePolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:CreateRepository",
                "ecr:PutImageScanningConfiguration",
                "ecr:GetDownloadUrlForLayer",
                "ecr:DeleteLifecyclePolicy",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:GetRepositoryPolicy"]
    resources = ["arn:aws:ecr:*:*:repository/${var.repository}"]
  }
}

resource "aws_iam_user_policy" "github" {
  name = "ecr"
  user = aws_iam_user.github.name
  policy = data.aws_iam_policy_document.ecr.json
}

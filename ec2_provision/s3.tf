resource "aws_s3_bucket" "state" {
  bucket = "adeyomola-tfstate-bucket"
  region = var.region
}

data "aws_iam_policy_document" "allow_terraform" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::adeyomola-tfstate-bucket"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::adeyomola-tfstate-bucket/terraform_state"]
  }
}

resource "aws_s3_bucket_policy" "backend_permissions" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.allow_terraform.json
}


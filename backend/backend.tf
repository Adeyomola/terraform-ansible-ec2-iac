terraform {
  backend "s3" {
    bucket = "adeyomola-tfstate-bucket"
    key    = "terraform_state"
    region = "var.region"
  }
}

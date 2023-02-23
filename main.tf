terraform {
  backend "s3" {
    bucket         = "adeyomola-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "adeyomola_dynamodb"
  }
}

module "ec2_provision" {
  source     = "./ec2_provision"
  public_key = var.public_key
}


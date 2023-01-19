terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    namecheap = {
      source  = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }
}

#Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Namecheap API credentials
provider "namecheap" {
  user_name   = var.namecheap_username
  api_user    = var.namecheap_api_user
  api_key     = var.namecheap_api_key
  use_sandbox = false
}

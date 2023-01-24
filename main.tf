variable public_key {}

module "ec2_provision" {
  source     = "./ec2_provision"
  public_key = var.public_key
}

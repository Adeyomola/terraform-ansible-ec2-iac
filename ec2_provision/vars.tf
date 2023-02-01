#Create variables
variable "public_key" {
  sensitive = true
}

variable "instance_base_name" {
  type    = string
  default = "triserver"
}
variable "ingress_ports" {
  type    = list(any)
  default = [80, 22]
}

variable "instances_index" {
  type    = set(string)
  default = ([1, 2, 3])
}

variable "cidr" {
  type = map(any)
  default = {
    1 = ["10.0.1.0/24", "a"]
    2 = ["10.0.2.0/24", "b"]
  }
}

variable "region" {
  default = "us-east-1"
}

variable "domain_name" {
  type    = string
  default = "adeyomola.me"
}
#variable "namecheap_api_user" {}
#variable "namecheap_api_key" {}
#variable "namecheap_username" {}

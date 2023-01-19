#Create variables
variable "public_key" {}
variable "ingress_ports" {
  type    = list(any)
  default = [80, 22]
}
variable "my_ip" {}
variable "namecheap_api_user" {}
variable "namecheap_api_key" {}
variable "namecheap_username" {}

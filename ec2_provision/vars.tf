#Create variables
variable "public_key" {
  sensitive = true
}
variable "ingress_ports" {
  type    = list(any)
  default = [80, 22]
}
#variable "namecheap_api_user" {}
#variable "namecheap_api_key" {}
#variable "namecheap_username" {}

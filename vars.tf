#Create variables
variable "public_key" {}
variable "ingress_ports" {
  type    = list(any)
  default = [80, 22]
}

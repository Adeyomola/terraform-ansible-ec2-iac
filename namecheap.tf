resource "namecheap_domain_records" "mydomain" {
  domain     = "adeyomola.me"
  mode       = "OVERWRITE"
  email_type = "NONE"

  record {
    hostname = "terraform-test"
    type     = "NS"
    address  = aws_route53_zone.primary.name_servers
    ttl      = 300
  }
}

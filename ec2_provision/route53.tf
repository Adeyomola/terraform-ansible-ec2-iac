resource "aws_route53_zone" "primary" {
  name = "terraform-test.adeyomola.me"
}

resource "aws_route53_record" "r53" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "terraform-test.adeyomola.me"
  type    = "A"
  alias {
    name                   = aws_lb.triserver_alb.dns_name
    zone_id                = aws_lb.triserver_alb.zone_id
    evaluate_target_health = true
  }
}

output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}

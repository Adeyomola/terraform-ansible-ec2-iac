resource "aws_route53_zone" "primary" {
  name = "adeyomola.me"
}

resource "aws_route53_record" "r53_2" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "terraform-test.adeyomola.me"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.triserver_alb.dns_name]
}

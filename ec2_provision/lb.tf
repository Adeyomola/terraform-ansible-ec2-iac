resource "aws_lb_target_group" "triserver_tg" {
  name     = "triserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.triserver_vpc.id
}

resource "aws_lb_target_group_attachment" "triserver_tg_attachment1" {
  for_each         = aws_instance.triserver
  target_group_arn = aws_lb_target_group.triserver_tg.arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb" "triserver_alb" {
  name               = "triserver-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.triserver_sg.id]
  subnets            = [aws_subnet.triserver_subnet["1"].id, aws_subnet.triserver_subnet["2"].id]
}

resource "aws_lb_listener" "triserver_lb_listener" {
  load_balancer_arn = aws_lb.triserver_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.triserver_tg.arn
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Create variables
variable "public_key" {}

#Import public key of localhost to AWS
resource "aws_key_pair" "vagrant" {
  key_name   = "vagrant"
  public_key = file(var.public_key)
}

resource "aws_vpc" "triserver_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "triserver_vpc"
  }
}

resource "aws_internet_gateway" "triserver_igw" {
  vpc_id = aws_vpc.triserver_vpc.id
}

resource "aws_subnet" "triserver_subnet1" {
  vpc_id            = aws_vpc.triserver_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "triserver_subnet1"
  }
}

resource "aws_subnet" "triserver_subnet2" {
  vpc_id            = aws_vpc.triserver_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "triserver_subnet2"
  }
}

resource "aws_default_route_table" "triserver_rt" {
  default_route_table_id = aws_vpc.triserver_vpc.default_route_table_id

  route {
    gateway_id = aws_internet_gateway.triserver_igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "triserver_rt"
  }
}

resource "aws_route_table_association" "triserver_rta1" {
  subnet_id      = aws_subnet.triserver_subnet1.id
  route_table_id = aws_default_route_table.triserver_rt.id
}

resource "aws_route_table_association" "triserver_rta2" {
  subnet_id      = aws_subnet.triserver_subnet2.id
  route_table_id = aws_default_route_table.triserver_rt.id
}

resource "aws_security_group" "triserver_sg" {
  name        = "triserver_sg"
  description = "allow incoming traffic on port 80"
  vpc_id      = aws_vpc.triserver_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "triserver-1" {
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet1.id
  vpc_security_group_ids      = [aws_security_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "vagrant"

  tags = {
    Name = "triserver-1"
  }
}

resource "aws_instance" "triserver-2" {
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet2.id
  vpc_security_group_ids      = [aws_security_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "vagrant"

  tags = {
    Name = "triserver-2"
  }
}

resource "aws_instance" "triserver-3" {
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet1.id
  vpc_security_group_ids      = [aws_security_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "vagrant"

  tags = {
    Name = "triserver-3"
  }
}

resource "local_file" "host-inventory" {
  content  = "${aws_instance.triserver-1.public_dns}\n${aws_instance.triserver-2.public_dns}\n${aws_instance.triserver-3.public_dns}"
  filename = "${path.cwd}/host-inventory"

  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.cwd}/host-inventory ${path.cwd}/playbook.yml"
  }
}

resource "aws_lb_target_group" "triserver_tg" {
  name     = "triserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.triserver_vpc.id
}

resource "aws_lb_target_group_attachment" "triserver_tg_attachment1" {
  target_group_arn = aws_lb_target_group.triserver_tg.arn
  target_id        = aws_instance.triserver-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "triserver_tg_attachment2" {
  target_group_arn = aws_lb_target_group.triserver_tg.arn
  target_id        = aws_instance.triserver-2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "triserver_tg_attachment3" {
  target_group_arn = aws_lb_target_group.triserver_tg.arn
  target_id        = aws_instance.triserver-3.id
  port             = 80
}

resource "aws_lb" "triserver_alb" {
  name               = "triserver-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.triserver_sg.id]
  subnets            = [aws_subnet.triserver_subnet1.id, aws_subnet.triserver_subnet2.id]
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

resource "aws_route53_zone" "primary" {
  name = "adeyomola.me"
}

resource "aws_route53_record" "r53" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "terraform-test.adeyomola.me"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.triserver_alb.dns_name]
}


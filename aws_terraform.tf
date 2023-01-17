terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "triserver_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "triserver_vpc"
  }
}

resource "aws_internet_gateway" "triserver_igw" {
  vpc_id = aws_vpc.triserver_vpc.id
}

resource "aws_subnet" "triserver_subnet" {
  vpc_id            = aws_vpc.triserver_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "1a"
  tags = {
    Name = "triserver_subnet"
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

resource "aws_route_table_association" "triserver_rta" {
  subnet_id      = aws_subnet.triserver_subnet.id
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
  subnet_id                   = aws_subnet.triserver_subnet.id
  vpc_security_group_ids      = [aws_secruity_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "windows11"

  tags = {
    Name = "triserver-1"
  }
}

resource "aws_instance" "triserver-2" {
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet.id
  vpc_security_group_ids      = [aws_secruity_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "windows11"

  tags = {
    Name = "triserver-2"
  }
}

resource "aws_instance" "triserver-3" {
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet.id
  vpc_security_group_ids      = [aws_secruity_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "windows11"

  tags = {
    Name = "triserver-3"
  }
}

resource "local_file" "host-inventory" {
  content  = "${aws_instance.triserver-1} \n ${aws_instance.triserver-2} \n ${aws_instance.triserver-3}"
  filename = "${path.cwd}/host-inventory"
}

resource "aws_elb" "triserver_elb" {

}

resource "aws_route53_record" "r53" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "terraform-test.adeyomola.me"
  type    = "A"
  ttl     = 300
  records = [aws_eip.lb.public_ip]
}

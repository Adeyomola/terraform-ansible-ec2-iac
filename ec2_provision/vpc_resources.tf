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

resource "aws_subnet" "triserver_subnet" {
  vpc_id            = aws_vpc.triserver_vpc.id
  for_each          = var.cidr
  cidr_block        = each.value[0]
  availability_zone = "${var.region}${each.value[1]}"
  tags = {
    Name = "triserver_subnet${each.key}"
  }
}

#resource "aws_subnet" "triserver_subnet2" {
#  vpc_id            = aws_vpc.triserver_vpc.id
#  cidr_block        = "10.0.2.0/24"
#  availability_zone = "us-east-1b"
#  tags = {
#    Name = "triserver_subnet2"
#  }
#}

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
  for_each       = aws_subnet.triserver_subnet
  subnet_id      = each.value.id
  route_table_id = aws_default_route_table.triserver_rt.id
}

#resource "aws_route_table_association" "triserver_rta2" {
#  subnet_id      = aws_subnet.triserver_subnet["triserver_subnet2"].id
#  route_table_id = aws_default_route_table.triserver_rt.id
#}

#Import public key of localhost to AWS
resource "aws_key_pair" "vagrant" {
  key_name   = "vagrant"
  public_key = file(var.public_key)
}

resource "aws_instance" "triserver" {
  count                       = 3
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet1.id
  vpc_security_group_ids      = [aws_security_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "vagrant"

  tags = {
    Name = "triserver-${count.index}"
  }
}

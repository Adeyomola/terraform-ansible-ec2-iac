#Import public key of localhost to AWS
resource "aws_key_pair" "vagrant" {
  key_name   = "vagrant"
  public_key = file(var.public_key)
}

resource "aws_instance" "triserver" {
  for_each                    = var.instances_index
  instance_type               = "t2.micro"
  ami                         = "ami-0574da719dca65348"
  subnet_id                   = aws_subnet.triserver_subnet["1"].id
  vpc_security_group_ids      = [aws_security_group.triserver_sg.id]
  associate_public_ip_address = true
  key_name                    = "vagrant"

  tags = {
    Name = "${var.instance_base_name}-${each.value}"
  }
}

resource "local_file" "host-inventory" {
  content  = "${aws_instance.triserver.0.public_dns}\n${aws_instance.triserver.1.public_dns}\n${aws_instance.triserver.2.public_dns}"
  filename = "${path.cwd}/host-inventory"
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.cwd}/host-inventory ${path.cwd}/playbook.yml"
  }
}

resource "local_file" "host-inventory" {
  content  = "${aws_instance.triserver.0.public_dns}\n${aws_instance.triserver.1.public_dns}\n${aws_instance.triserver.2.public_dns}"
  filename = "${path.cwd}/ansible/host-inventory"
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.cwd}/ansible/host-inventory ${path.cwd}/ansible/playbook.yml"
  }
}

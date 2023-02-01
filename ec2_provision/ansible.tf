resource "local_file" "host-inventory" {
  content  = "${aws_instance.triserver[1].public_dns}\n${aws_instance.triserver[2].public_dns}\n${aws_instance.triserver[3].public_dns}"
  filename = "${path.cwd}/ec2_provision/ansible/host-inventory"
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.cwd}/ec2_provision/ansible/host-inventory ${path.cwd}/ec2_provision/ansible/playbook.yml"
  }
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  key_name      = var.key_name
  user_data     = file(var.user_data_script)

  tags = {
    Name = "DockerInstance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip",
      "pip3 install ansible"
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.key_name}.pem playbook.yml"
  }
}

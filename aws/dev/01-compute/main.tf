# Creates an EBS volume in the specified availability zone, with encryption enabled.
resource "aws_ebs_volume" "server_volume" {
  availability_zone = var.az
  size              = 200
  encrypted = true

  tags = {
    Name = var.name_tag
  }
}

# Attaches the specified EBS volume to an EC2 instance.
resource "aws_volume_attachment" "server_attachment" {
  device_name = "/dev/sdx"
  volume_id   = aws_ebs_volume.server_volume.id
  instance_id = aws_instance.server_machine.id

  force_detach = true
}

# Contents of the files
locals {
  nginx_cert_contents = file(var.nginx_cert_key_path)
  nginx_key_contents = file(var.nginx_key_path)
}

# Provisions an EC2 instance with the specified AMI, instance type, and attached to the defined VPC, subnet, and security group.
resource "aws_instance" "server_machine" {
    ami = "ami-xxx"
    instance_type = "c6i.xlarge"
    availability_zone = var.az
    vpc_security_group_ids = [aws_security_group.server_machine_sg.id]
    subnet_id = aws_subnet.tools_poc_machine_subnet.id

    associate_public_ip_address = true

    key_name = aws_key_pair.admin_public_key_path.key_name

    user_data = templatefile("${path.module}/user_data.sh", {
      server_key = aws_key_pair.prod_tools_auth_key_alex.public_key,
      admin_key = aws_key_pair.admin_public_key_path.public_key,
      nginx_cert_key = local.nginx_cert_contents,
      nginx_key = local.nginx_key_contents,
      github_token = var.github_token
    })

    tags = {
        Name = "${var.name_tag} new"
    }
}
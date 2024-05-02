# Creates an EBS volume in the specified availability zone, with encryption enabled.
resource "aws_ebs_volume" "prod_tools_volume" {
  availability_zone = var.az
  size              = 200
  encrypted = true

  tags = {
    Name = var.name_tag
  }
}

# Attaches the specified EBS volume to an EC2 instance.
resource "aws_volume_attachment" "prod_tools_attachment" {
  device_name = "/dev/sdx"
  volume_id   = aws_ebs_volume.prod_tools_volume.id
  instance_id = aws_instance.prod_tools_machine.id

  force_detach = true
}

# Contents of the files
locals {
  nginx_cert_contents = file(var.nginx_cert_key_path)
  nginx_key_contents = file(var.nginx_key_path)
}

# Provisions an EC2 instance with the specified AMI, instance type, and attached to the defined VPC, subnet, and security group.
resource "aws_instance" "prod_tools_machine" {
    ami = "ami-0911e88fb4687e06b"
    instance_type = "c6i.xlarge"
    availability_zone = var.az
    vpc_security_group_ids = [data.terraform_remote_state.net_sec_remote_data.outputs.prod_tools_machine_sg_id,
                              data.terraform_remote_state.net_sec_remote_data.outputs.prod_tools_machine_sg_grafana_id]
    subnet_id = data.terraform_remote_state.net_sec_remote_data.outputs.aws_subnet_id

    associate_public_ip_address = true

    key_name = aws_key_pair.prod_tools_auth_key_.key_name

    user_data = templatefile("${path.module}/user_data.sh", {
      admin1_key = aws_key_pair.prod_tools_auth_key_admin1.public_key,
      admin2leen_key = aws_key_pair.prod_tools_auth_key_admin2leen.public_key,
      nginx_cert_key = local.nginx_cert_contents,
      nginx_key = local.nginx_key_contents,
      github_token = var.github_token
    })

    tags = {
        Name = var.name_tag
    }
}

# Associates an Elastic IP address with an EC2 instance.
resource "aws_eip_association" "prod_tools_eip_assoc" {
  instance_id   = aws_instance.prod_tools_machine.id
  allocation_id = data.terraform_remote_state.net_sec_remote_data.outputs.elastic_ip_id
}
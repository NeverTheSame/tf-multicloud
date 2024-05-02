# Uploads a public key to AWS to be used for SSH access to EC2 instances.
resource "aws_key_pair" "prod_tools_auth_key_admin" {
  key_name = "admin-tools-machine-key"
  public_key = file(var.admin_public_key_path)

  tags = {
    Name = var.name_tag
  }
}

resource "aws_key_pair" "prod_tools_auth_key_admin1" {
  key_name = "admin1-tools-machine-key"
  public_key = file(var.admin1_public_key_path)

  tags = {
    Name = var.name_tag
  }
}

resource "aws_key_pair" "prod_tools_auth_key_admin2leen" {
  key_name = "admin2leen-tools-machine-key"
  public_key = file(var.admin2leen_public_key_path)

  tags = {
    Name = var.name_tag
  }
}
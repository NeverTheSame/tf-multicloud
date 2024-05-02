# Uploads a public key to AWS to be used for SSH access to EC2 instances.
resource "aws_key_pair" "server_auth_key" {
  key_name = "dev_ed25519"
  public_key = file(var.public_key_path)

  tags = {
    Name = var.name_tag
  }
}

# Uploads a public key to AWS to be used for SSH access to EC2 instances.
resource "aws_key_pair" "server_auth_key_2" {
  key_name = "machine-key-1"
  public_key = file(var.admin_public_key_path)

  tags = {
    Name = var.name_tag
  }
}

resource "aws_key_pair" "prod_tools_auth_key_alex" {
  key_name = "machine-key-2"
  public_key = file(var.server_public_key_path)

  tags = {
    Name = var.name_tag
  }
}
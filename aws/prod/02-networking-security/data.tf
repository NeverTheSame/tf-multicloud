# Retrieves information about a specific Elastic IP address.
data "aws_eip" "server_poc_eip" {
  id = var.elastic_ip_alloc
}


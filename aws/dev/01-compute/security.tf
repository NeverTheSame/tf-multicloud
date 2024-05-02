# Defines a security group within the VPC for the tools POC machine, providing a layer of network security.
resource "aws_security_group" "server_machine_sg" {
    name   = "${var.name_tag}-machine-sg"
    vpc_id = aws_vpc.server_machine_vpc.id
    tags = {
        Name = var.name_tag
    }
}

# Security group rule to allow inbound traffic on port 8080 for Server applications.
resource "aws_security_group_rule" "server_ingress" {
  for_each          = { for item in var.whitelisted_cidr_blocks_full_access : item.cidr_block => item }
  description       = "SS Ingress for ${element(split("@", each.value.email), 0)}"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [each.key]

  security_group_id = aws_security_group.server_machine_sg.id
}

# Security group rule to allow inbound SSH traffic on port 22.
resource "aws_security_group_rule" "ssh_ingress" {
  for_each          = { for item in var.whitelisted_cidr_blocks_full_access : item.cidr_block => item }
  description       = "SSH Inbound Traffic for ${element(split("@", each.value.email), 0)}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [each.key]

  security_group_id = aws_security_group.server_machine_sg.id
}

# Security group rule to allow inbound traffic for InfluxDB on port 8086.
resource "aws_security_group_rule" "influx_ingress" {
  for_each          = { for item in var.whitelisted_cidr_blocks_full_access : item.cidr_block => item }
  description       = "InfluxDB Inbound Traffic for ${element(split("@", each.value.email), 0)}"
  type              = "ingress"
  from_port         = 8086
  to_port           = 8086
  protocol          = "tcp"
  cidr_blocks       = [each.key]

  security_group_id = aws_security_group.server_machine_sg.id
}

# Security group rule to allow inbound traffic for Grafana on port 443.
resource "aws_security_group_rule" "grafana_ingress" {
  for_each          = { for item in var.whitelisted_cidr_blocks_full_access : item.cidr_block => item }
  description       = "Grafana Inbound Traffic for ${element(split("@", each.value.email), 0)}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [each.key]

  security_group_id = aws_security_group.server_machine_sg.id
}

# Security group rules for users with no ssh access
resource "aws_security_group_rule" "grafana_ingress_no_ssh" {
  for_each          = { for item in var.whitelisted_cidr_blocks_web_access : item.cidr_block => item }
  description       = "Grafana Inbound Traffic for ${element(split("@", each.value.email), 0)}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [each.key]

  security_group_id = aws_security_group.server_machine_sg.id
}

resource "aws_security_group_rule" "ss_ingress_no_ssh" {
  for_each          = { for item in var.whitelisted_cidr_blocks_web_access : item.cidr_block => item }
  description       = "SS Ingress for ${element(split("@", each.value.email), 0)}"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [each.key]

  security_group_id = aws_security_group.server_machine_sg.id
}

# Security group rule for allowing outbound HTTP traffic on port 80.
resource "aws_security_group_rule" "egress_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_machine_sg.id
}

# Security group rule for allowing outbound HTTPS traffic on port 443.
resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server_machine_sg.id
}
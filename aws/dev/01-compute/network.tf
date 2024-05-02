# Creates a new VPC for the tools POC machine with specified CIDR block and enables DNS hostnames.
resource "aws_vpc" "server_machine_vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    tags = {
        Name = var.name_tag
    }
}

# Creates a subnet within the specified VPC and availability zone, enabling public IPs for instances launched in this subnet.
resource "aws_subnet" "server_machine_subnet" {
    vpc_id     = aws_vpc.server_machine_vpc.id
    availability_zone = var.az
    cidr_block = var.subnet_cidr_block
    map_public_ip_on_launch = true
    tags = {
        Name = var.name_tag
    }
}

# Creates an Internet Gateway and attaches it to the VPC, facilitating communication between the VPC and the internet.
resource "aws_internet_gateway" "server_poc_igw" {
    vpc_id = aws_vpc.server_machine_vpc.id
    tags = {
        Name = var.name_tag
    }
}

# Creates a route table for the VPC to define routing rules for network traffic.
resource "aws_route_table" "server_public_rt" {
  vpc_id = aws_vpc.server_machine_vpc.id
  tags = {
    Name = var.name_tag
  }
}

# Defines a route in the route table for directing traffic to the internet gateway.
resource "aws_route" "tools_poc_route" {
  route_table_id         = aws_route_table.server_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.server_poc_igw.id
}

# Associates the subnet with the specified route table, enabling the routing rules for the subnet.
resource "aws_route_table_association" "server_rta" {
  subnet_id      = aws_subnet.server_machine_subnet.id
  route_table_id = aws_route_table.server_public_rt.id
}

# Retrieves information about a specific Elastic IP address.
data "aws_eip" "server_eip" {
  id = "eipalloc-021ac4de56719f539"
}

# Associates an Elastic IP address with an EC2 instance.
resource "aws_eip_association" "server_eip_assoc" {
  instance_id   = aws_instance.server_machine.id
  allocation_id = data.aws_eip.server_eip.id
}
data "aws_vpc" "demo_machine_vpc" {
    default = true
}

data "aws_security_group" "demo_machine_sg" {
    name = "launch-wizard-2"
}

data "aws_instance" "tools_machine" {
    instance_id = "i-xxx"
}

data "aws_eip" "demo_server_ip" {
    public_ip = "1.1.1.1"
}
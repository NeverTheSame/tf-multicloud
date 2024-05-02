output "prod_tools_machine_ip" {
  value = aws_instance.prod_tools_machine.public_ip
}
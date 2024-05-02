output "prod_server_machine_sg_id" {
  value = aws_security_group.prod_server_machine_sg.id
}

output "prod_server_machine_sg_grafana_id" {
  value = aws_security_group.prod_server_machine_sg_grafana.id
}

output "aws_subnet_id" {
  value = aws_subnet.prod_server_machine_subnet.id
}

output "elastic_ip_id" {
  value = data.aws_eip.server_poc_eip.id
}



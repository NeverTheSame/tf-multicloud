variable "public_key_path" {}
variable "whitelisted_cidr_blocks_full_access" {}
variable "whitelisted_cidr_blocks_web_access" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "az" {}
variable "name_tag" {}
variable "admin_public_key_path" {}
variable "server_public_key_path" {}
variable "nginx_cert_key_path" {}
variable "nginx_key_path" {}
variable "github_token" {
  type = string
  sensitive = true
}
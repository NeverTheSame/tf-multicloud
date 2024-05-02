variable "name_tag" {}
variable "az" {}
variable "admin_public_key_path" {}
variable "admin1_public_key_path" {}
variable "admin2leen_public_key_path" {}
variable "nginx_cert_key_path" {}
variable "nginx_key_path" {}
variable "github_token" {
  type = string
  sensitive = true
}
# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "gcs" {
    bucket = "server-infrastructure"
    prefix = "prod/06-ansible"
  }
}

# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
data "terraform_remote_state" "prod_folders_remote_data" {
  backend = "gcs"

  config = {
    bucket = "server-infrastructure"
    prefix = "prod/00-prod-folders"
  }
}

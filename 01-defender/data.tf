# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
data "terraform_remote_state" "projects_remote_data" {
  backend = "gcs"

  config = {
    bucket = "infra"
    prefix = "00-folders-projects"
  }
}
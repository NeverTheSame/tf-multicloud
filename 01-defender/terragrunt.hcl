include "root" {
  path = find_in_parent_folders()
}

generate "data_tf" {
  path      = "data.tf"
  if_exists = "overwrite"
  contents  = <<EOF
data "terraform_remote_state" "projects_remote_data" {
  backend = "gcs"

  config = {
    bucket = "infra"
    prefix = "00-folders-projects"
  }
}
EOF
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  region = "us-west1"
  project = var.mgmt_project_id
}

provider "google-beta" {
  region = "us-west1"
  project = var.mgmt_project_id
}
EOF
}

inputs = {

}

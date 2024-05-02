locals {
  // Extracting API names (keys) from the dictionary
  prod_project_api_names = keys(var.prod_project_apis)
}

module "prod_bb_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "14.3.0"

  name                           = "production"
  random_project_id              = true
  org_id                         = var.org_id
  billing_account                = var.billing_id
  enable_shared_vpc_host_project = true
  activate_apis                  = local.prod_project_api_names
  folder_id                      = data.terraform_remote_state.prod_folders_remote_data.outputs.prod_barebone_folder_id
}

module "prod_k8s_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "14.3.0"

  name                           = "production"
  random_project_id              = true
  org_id                         = var.org_id
  billing_account                = var.billing_id
  enable_shared_vpc_host_project = true
  folder_id                      = data.terraform_remote_state.prod_folders_remote_data.outputs.prod_k8s_folder_id
}
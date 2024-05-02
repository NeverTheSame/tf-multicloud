module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "7.3.0"

  project_id   = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  network_name = "prod-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "prod-subnet"
      subnet_ip             = var.subnet_ip
      subnet_region         = var.region
      subnet_private_access = "true"
    }
  ]
}
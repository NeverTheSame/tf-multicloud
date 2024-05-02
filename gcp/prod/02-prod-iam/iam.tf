resource "google_service_account" "vpc_vm_service_account" {
  account_id   = "vpc-vm-admin"
  display_name = "Service Account for VPC and VM Management for production barebone project"
  project      = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
}

resource "google_project_iam_binding" "network_admin" {
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  role    = "roles/compute.networkAdmin"

  members = [
    "serviceAccount:${google_service_account.vpc_vm_service_account.email}",
  ]
}

resource "google_project_iam_binding" "instance_admin" {
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.vpc_vm_service_account.email}",
  ]
}
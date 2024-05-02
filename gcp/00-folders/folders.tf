## Module: root_folder
## This module creates a top-level folder within a GCP organization, serving as the primary organizational unit under
## which environment-specific folders and resources will be structured. It leverages the
## "terraform-google-modules/folders/google" module for folder creation, ensuring consistency and adherence to best
## practices in GCP resource management.
##
## Attributes:
## - source: Specifies the Terraform module source for GCP folder management.
## - version: Locks the module to version "4.0.0", ensuring compatibility and stability.
## - parent: The ID of the GCP organization under which the root folder will be created, denoted by "var.org_id".
## - names: A list of names for the root folder, derived from "var.root_folder_name", indicating the intended use or
##   organizational structure.
module "root_folder" {
  source  = "terraform-google-modules/folders/google"
  version = "4.0.0"
  parent  = "organizations/${var.org_id}"
  names   = var.root_folder_name
}
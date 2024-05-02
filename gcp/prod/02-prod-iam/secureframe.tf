# Satisfy https://app.secureframe.com/integrations/connect/google_cloud requirements
# Step 3: Enable Google Cloud APIs
# Enable Cloud Key Management Service (KMS) API
resource "google_project_service" "kms_api" {
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Logging API
resource "google_project_service" "logging_api" {
  service            = "logging.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud SQL Admin API
resource "google_project_service" "sql_admin_api" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

# Enable Compute Engine API
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# Enable Container Scanning API (Conditional)
resource "google_project_service" "container_scanning_api" {
  service            = "containerscanning.googleapis.com"
  disable_on_destroy = false
}

# Enable Kubernetes Engine API
resource "google_project_service" "kubernetes_api" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# Enable Service Management API
resource "google_project_service" "service_management_api" {
  service            = "servicemanagement.googleapis.com"
  disable_on_destroy = false
}

# Enable Service Networking API
resource "google_project_service" "service_networking_api" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

# Enable Service Usage API
resource "google_project_service" "service_usage_api" {
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

# Enable Stackdriver Monitoring API
resource "google_project_service" "monitoring_api" {
  service            = "monitoring.googleapis.com"
  disable_on_destroy = false
}

# Step 4: Create a SecureframeScanner role
resource "google_organization_iam_custom_role" "secureframe_scanner" {
  org_id     = var.org_id
  role_id    = "SecureframeScanner"
  title      = "SecureframeScanner"
  description = "Role assigned to service account for the Secureframe integration to operate against specific Projects"
  permissions = [
    "bigtable.instances.get",
    "bigquery.datasets.get",
    "compute.instances.get",
    "compute.projects.get",
    "compute.subnetworks.get",
    "pubsub.topics.get",
    "resourcemanager.projects.get",
    "storage.buckets.get",
  ]
  stage = "GA"
}

# Step 5: Create a SecureframeProjectScanner role
resource "google_organization_iam_custom_role" "secureframe_project_scanner" {
  org_id     = var.org_id
  role_id    = "SecureframeProjectScanner"
  title      = "SecureframeProjectScanner"
  description = "Role assigned to service account for Secureframe integration"
  permissions = [
    "iam.roles.list",
    "resourcemanager.organizations.getIamPolicy",
    "resourcemanager.folders.getIamPolicy",
  ]
  stage = "GA"
}

# Step 6: Create a Service Account
resource "google_service_account" "secureframe_service_account" {
  account_id   = "secureframe-service-account"
  display_name = "Secureframe Service Account"
  project      =  data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  description  = "Secureframe Service Account"
}

resource "google_project_iam_member" "secureframe_scanner_role" {
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  role    = "organizations/${var.org_id}/roles/SecureframeScanner"
  member  = "serviceAccount:${google_service_account.secureframe_service_account.email}"
}

resource "google_project_iam_member" "secureframe_org_scanner_role" {
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  role    = "organizations/${var.org_id}/roles/SecureframeProjectScanner"
  member  = "serviceAccount:${google_service_account.secureframe_service_account.email}"
}

resource "google_project_iam_member" "security_reviewer_role" {
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  role    = "roles/iam.securityReviewer"
  member  = "serviceAccount:${google_service_account.secureframe_service_account.email}"
}
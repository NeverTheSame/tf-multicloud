resource "google_storage_bucket" "barebone_backups_bucket" {
  name                        = "barebone-backups"
  location                    = "US"
  force_destroy               = true # Allows all objects in the bucket to be destroyed along with the bucket.
  storage_class               = "STANDARD"
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id

  uniform_bucket_level_access = true # Enables Uniform Bucket-Level Access to enforce IAM-style permissions.

  lifecycle_rule {
    condition {
      age = 365 # Specifies conditions under which objects should be automatically transitioned to a different storage class or deleted.
    }
    action {
      type          = "Delete"
    }
  }
}

resource "google_storage_bucket_object" "folder_object" {
  name   = "platform-backups/"
  bucket = google_storage_bucket.barebone_backups_bucket.name
  source = "empty.txt"
}
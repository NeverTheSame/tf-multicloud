resource "google_folder" "production" {
  display_name = "production"
  parent       = data.terraform_remote_state.root_folder_remote_data.outputs.root_folder_id
}

resource "google_folder" "production_barebone" {
  display_name = "barebone"
  parent       = google_folder.production.id
}

resource "google_folder" "production_k8s" {
  display_name = "k8s"
  parent       = google_folder.production.id
}
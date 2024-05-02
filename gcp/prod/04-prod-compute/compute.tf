resource "google_service_account" "default" {
  account_id   = "compute-sa"
  display_name = "Custom SA for VM Instance"
  project = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
}

resource "google_compute_instance" "ad-server" {
  name         = "ad-server"
  machine_type = "c2d-highcpu-16"
  zone         = "us-west1-b"
  project      = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id

  boot_disk {
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
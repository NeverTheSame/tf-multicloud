# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration
data "google_compute_network" "prod_vpc" {
  name = "prod-vpc"
  project      = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
}


resource "google_compute_instance" "ansible-server" {
  project      = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  boot_disk {
    auto_delete = true
    device_name = "ansible-server"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240319"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  tags = ["ssh-assist"]


  machine_type = "e2-medium"
  name         = "ansible-server"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    network = data.google_compute_network.prod_vpc.self_link
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/production/regions/us-west1/subnetworks/prod-subnet"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "XXX-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "us-west1-b"

  desired_status = "RUNNING"

  metadata = {
    "ssh-keys" = "${var.ssh_user}:${file("secret/id_rsa.pub")}"
  }

}

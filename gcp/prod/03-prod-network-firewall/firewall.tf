resource "google_compute_firewall" "all_traffic" {
  name        = "all-traffic"
  description = "Allow all traffic from whitelisted IP addresses"
  project     = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  network     = module.vpc.network_name
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [for item in var.all_traffic_whitelisted_ip_addresses : item.ip]
  target_tags   = ["all-traffic-access"]

  allow {
    protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

### sg-0cd94008b20c339d3 | launch-wizard-1
resource "google_compute_firewall" "rdp_ingress" {
  name        = "lw-rdp"
  description = "Allow RDP traffic"
  project     = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  network     = module.vpc.network_name
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [for item in var.rdp_whitelisted_ip_addresses : item.ip]
  target_tags   = ["lw-rdp"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}



resource "google_compute_firewall" "redis_traffic" {
  name        = "lw-redis"
  description = "Allow Redis traffic from whitelisted IP addresses"
  project     = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  network     = module.vpc.network_name
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [for item in var.redis_whitelisted_ip_addresses : item.ip]
  target_tags   = ["lw-redis"]

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "https_traffic" {
  name        = "lw-https"
  description = "Allow HTTPS traffic from whitelisted IP addresses"
  project     = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  network     = module.vpc.network_name
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [for item in var.https_whitelisted_ip_addresses : item.ip]
  target_tags   = ["lw-https"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_all_ports_from_YYY3" {
  name          = "XXX-tcp-all-ports-from-YYY3"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.YYY3_internal_ip]

  target_tags   = ["XXX-tcp-all-ports-from-YYY3"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_all_ports_for_XXX_multiple_sources" {
  name          = "XXX-all-tcp-automatic-YYY3-YYY4"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [
    var.automatic_server_internal_ip,
    var.YYY3_internal_ip,
    var.YYY4_internal_ip,
  ]

  target_tags   = ["XXX-all-tcp-automatic-YYY3-YYY4"]

  allow {
    protocol = "tcp"
    ports    = ["0-65534"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "allow_all_connection_XXX" {
  name          = "XXX-allow-all-from-specific-ips-XXX"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [for item in var.allow_all_traffic_for_XXX_ips_map : item.ip]

  target_tags   = ["XXX-allow-all-from-specific-ips-XXX"]

  allow {
    protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_49325_from_YYY_machine" {
  name          = "XXX-tcp-49325-from-YYY-machine"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["172.31.33.90/32"]

  target_tags   = ["YYY-traffic"]

  allow {
    protocol = "tcp"
    ports    = ["49325"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  disabled = true
}

resource "google_compute_firewall" "tcp_from_ZZZ_server" {
  name          = "XXX-tcp-4840-from-ZZZ-server"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["172.31.25.232/32"]

  target_tags   = ["ZZZ-traffic"]

  allow {
    protocol = "tcp"
    ports    = ["4840"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = true
}

resource "google_compute_firewall" "tcp_3389_rdp_access_XXX" {
  name          = "XXX-rdp"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [for item in var.tcp_3389_rdp_access_XXX_map : item.ip]

  target_tags   = ["XXX-rdp"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "allow_icmp_XXX" {
  name          = "XXX-icmp"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [
    "172.31.14.71/32",
    var.internal_ipv4_cidr
  ]

  allow {
    protocol = "icmp"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  target_tags = ["XXX-icmp"]

  disabled = false
}


resource "google_compute_firewall" "automatic_rdp_access" {
  name          = "ig-rdp-access"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [for item in var.ig_rdp_ips : item.ip]
  target_tags   = ["ig-rdp-access"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "automatic_ping" {
  name          = "ig-ping"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.internal_ipv4_cidr]
  target_tags   = ["ig-ping"]

  allow {
    protocol = "icmp"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_49320_software1_ZZZ" {
  name          = "ig-tcp-49320-software1-ZZZ"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.internal_ipv4_cidr]
  target_tags   = ["ig-tcp-49320-software1-ZZZ"]

  allow {
    protocol = "tcp"
    ports    = ["49320"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}


resource "google_compute_firewall" "tcp_YYY1_automatic" {
  name          = "ig-tcp-YYY1"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["172.31.6.190/32"]
  target_tags   = ["ig-tcp-YYY1"]

  allow {
    protocol = "tcp"
    ports    = ["4841", "49322"]
  }


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_all_ports_XXX_automatic" {
  name          = "ig-tcp-all-ports-XXX"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.YYY3_internal_ip, var.XXX_server_internal_ip]
  target_tags   = ["ig-tcp-all-ports-XXX"]

  allow {
    protocol = "tcp"
    ports    = ["0-65534"]
  }


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "allow_all_from_ad_server" {
  name          = "ig-allow-all-from-ad-server"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.ad_server_internal_ip]
  target_tags   = ["ig-allow-all-from-ad-server"]

  allow {
    protocol = "all"
  }


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_135_opc_da_dcom_automatic" {
  name          = "ig-tcp-135-opc-da-dcom"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.internal_ipv4_cidr]
  target_tags   = ["ig-tcp-135-opc-da-dcom"]

  allow {
    protocol = "tcp"
    ports    = ["135"]
  }


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "tcp_8088_web_interface_automatic" {
  name          = "ig-tcp-8088-web-interface"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.internal_ipv4_cidr]
  target_tags   = ["ig-tcp-8088-web-interface"]

  allow {
    protocol = "tcp"
    ports    = ["8088"]
  }


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}

resource "google_compute_firewall" "ssh_assist" {
  name          = "ssh-assist"
  network       = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [for item in var.ssh_assist_whitelisted_ip_addresses : item.ip]
  target_tags   = ["ssh-assist"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  disabled = false
}


## Ansible WinRM
resource "google_compute_firewall" "allow_winrm" {
  name    = "allow-winrm"
  network = module.vpc.network_name
  project       = data.terraform_remote_state.production_project_remote_data.outputs.prod_barebone_project_id

  allow {
    protocol = "tcp"
    ports    = ["5986", "5985"]
  }

  source_ranges = ["172.31.0.63/32"]

  direction = "INGRESS"
  priority  = 1000


  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  description = "Allow WinRM traffic from ansible-server to all instances within the network on TCP port 5986"
}

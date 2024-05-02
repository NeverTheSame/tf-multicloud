locals {
    mgmt_project_name      = "Microsoft MGMT Project"
    IAMRoleID              = "MDCCustomRole"
    CspmCustomRoleID       = "MDCCspmCustomRole"
}

resource "google_project" "mgmt_project" {
  name = local.mgmt_project_name
  project_id = var.mgmt_project_id
  org_id = var.org_id
  billing_account = var.billing_id
}

resource "google_project_service" "gcp_apis" {
  count = length(var.enable_apis)
  project = google_project.mgmt_project.project_id
  service = element(var.enable_apis, count.index)
}

resource "google_organization_iam_custom_role" "ms_custom_role" {
  role_id = local.IAMRoleID
  org_id = var.org_id
  title = local.IAMRoleID
  description = "Microsoft organization custom role for onboarding"
  permissions = ["resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "serviceusage.services.enable", "iam.roles.create", "iam.roles.list", "iam.serviceAccounts.actAs", "compute.projects.get", "compute.projects.setCommonInstanceMetadata"]
}

resource "google_organization_iam_custom_role" "cspm_custom_role" {
  role_id     = local.CspmCustomRoleID
  title       = local.CspmCustomRoleID
  org_id      = var.org_id
  description = "Microsoft Defender for cloud CSPM custom role"
  permissions = var.use_least_privilege_access_permissions == true ? [
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.list",
    "cloudkms.keyRings.list",
    "cloudkms.keyRings.getIamPolicy",
    "apikeys.keys.list",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccountKeys.list",
    "iam.roles.list",
    "iam.roles.get",
    "iam.googleapis.com/workloadIdentityPoolProviders.get",
    "iam.googleapis.com/workloadIdentityPoolProviders.list",
    "iam.googleapis.com/workloadIdentityPools.get",
    "iam.googleapis.com/workloadIdentityPools.list",
    "bigquery.datasets.get",
    "bigquery.tables.get",
    "bigquery.tables.list",
    "bigquery.tables.getIamPolicy",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.folders.getIamPolicy",
    "resourcemanager.folders.list",
    "resourcemanager.organizations.getIamPolicy",
    "resourcemanager.organizations.get",
    "orgpolicy.policy.get",
    "compute.firewalls.list",
    "compute.networks.list",
    "compute.instances.list",
    "compute.projects.get",
    "compute.subnetworks.list",
    "compute.targetHttpsProxies.list",
    "compute.sslPolicies.list",
    "compute.targetSslProxies.list",
    "compute.disks.list",
    "compute.targetHttpProxies.list",
    "compute.globalForwardingRules.list",
    "compute.forwardingRules.list",
    "compute.urlMaps.list",
    "compute.instances.getEffectiveFirewalls",
    "compute.backendServices.list",
    "compute.instanceGroups.list",
    "compute.instanceTemplates.list",
    "compute.machineTypes.list",
    "compute.networks.list",
    "compute.networks.getEffectiveFirewalls",
    "compute.regionBackendServices.list",
    "compute.instanceGroupManagers.list",
    "compute.instanceGroupManagers.get",
    "compute.regionUrlMaps.list",
    "compute.regionTargetHttpProxies.list",
    "compute.regionTargetHttpsProxies.list",
    "compute.targetHttpsProxies.list",
    "compute.targetPools.list",
    "compute.targetTcpProxies.list",
    "dns.managedZones.list",
    "dns.policies.list",
    "logging.logMetrics.list",
    "logging.sinks.list",
    "logging.logEntries.list",
    "monitoring.alertPolicies.list",
    "cloudsql.instances.list",
    "storage.buckets.list",
    "storage.buckets.getiampolicy",
    "osconfig.osPolicyAssignments.list",
    "osconfig.osPolicyAssignmentReports.list",
    "container.clusters.list"
  ] : [
    "resourcemanager.folders.getIamPolicy",
    "resourcemanager.folders.list",
    "resourcemanager.organizations.get",
    "resourcemanager.organizations.getIamPolicy",
    "storage.buckets.getIamPolicy"
  ]
}

resource "google_iam_workload_identity_pool" "mdc_workload_identity_pool" {
  workload_identity_pool_id = var.workload_pool_id
  display_name = "Microsoft Defender for Cloud"
  description = "Microsoft defender for cloud provisioner workload identity pool"
  project = google_project.mgmt_project.project_id
}

resource "google_service_account" "onb_service_account" {
  account_id = "mdc-onboarding-sa"
  display_name = "Microsoft Onboarding management service account"
  project = google_project.mgmt_project.project_id
}

resource "google_organization_iam_binding" "onb_organization_role_binding" {
  role = "organizations/${var.org_id}/roles/${google_organization_iam_custom_role.ms_custom_role.role_id}"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.onb_service_account.email}"]
}

resource "google_service_account_iam_binding" "onb_workload_assignment" {
  service_account_id = google_service_account.onb_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "onb_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.auto_provisioner_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for autoprovisioner"
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://d17a7d74-7e73-4e7d-bd41-8d9525e86cab"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}

resource "google_service_account" "cspm_service_account" {
  account_id = "microsoft-defender-cspm"
  display_name = "Microsoft Defender CSPM"
  project = google_project.mgmt_project.project_id
}

resource "google_organization_iam_binding" "cspm_organization_role_binding" {
  role = "roles/viewer"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.cspm_service_account.email}",
    "serviceAccount:${google_service_account.ciem_service_account.email}"]
}

resource "google_organization_iam_binding" "cspm_organization_role_binding2" {
  role = "organizations/${var.org_id}/roles/${local.CspmCustomRoleID}"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.cspm_service_account.email}"]
}

resource "google_service_account_iam_binding" "cspm_workload_assignment" {
  service_account_id = google_service_account.cspm_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "cspm_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.cspm_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for CSPM"
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://6e81e733-9e7f-474a-85f0-385c097f7f52"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}

resource "google_iam_workload_identity_pool_provider" "containers_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.containers_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for Containers."
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://6610e979-c931-41ec-adc7-b9920c9d52f1"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}

resource "google_service_account" "containers_k8s_operator_service_account" {
  account_id = "mdc-containers-k8s-operator"
  display_name = "Microsoft Defender Containers Kubernetes Operator"
  project = var.mgmt_project_id
}

resource "google_service_account_iam_binding" "containers_k8s_operator_workload_assignment" {
  service_account_id = google_service_account.containers_k8s_operator_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_organization_iam_custom_role" "containers_gke_cluster_writer_iam_role" {
  role_id = "MDCGkeClusterWriteRole"
  title = "MDC GKE Cluster Write Role"
  org_id = var.org_id
  description = "MDC GKE Cluster Write Custom Role."
  permissions = ["container.clusters.update"]
  stage = "ALPHA"
}

resource "google_organization_iam_binding" "containers_k8s_operator_service_account_custom_role_binding" {
  org_id = var.org_id
  role = google_organization_iam_custom_role.containers_gke_cluster_writer_iam_role.id
  members = ["serviceAccount:${google_service_account.containers_k8s_operator_service_account.email}"]
}

resource "google_organization_iam_binding" "containers_k8s_operator_service_account_role_binding" {
  role = "roles/container.viewer"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_k8s_operator_service_account.email}"]
}

resource "google_service_account" "containers_image_assessment_service_account" {
  account_id = "mdc-containers-artifact-assess"
  display_name = "Microsoft Defender Containers Artifact Assessment"
  project = var.mgmt_project_id
}

resource "google_service_account_iam_binding" "containers_image_assessment_workload_assignment1" {
  service_account_id = google_service_account.containers_image_assessment_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_service_account_iam_binding" "containers_image_assessment_workload_assignment2" {
  service_account_id = google_service_account.containers_image_assessment_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_organization_iam_binding" "containers_image_assessment_service_account_role_binding1" {
  role = "roles/storage.objectUser"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_image_assessment_service_account.email}"]
}

resource "google_organization_iam_binding" "containers_image_assessment_service_account_role_binding2" {
  role = "roles/artifactregistry.writer"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_image_assessment_service_account.email}"]
}

resource "google_service_account" "containers_service_account" {
  account_id = "microsoft-defender-containers"
  display_name = "Microsoft Defender Containers"
  project = google_project.mgmt_project.project_id
}

resource "google_organization_iam_custom_role" "containers_iam_role" {
  role_id = "MicrosoftDefenderContainersRole"
  title = "Microsoft Defender Containers Custom Role"
  org_id = var.org_id
  description = "Microsoft Defender Containers Custom Role."
  permissions = ["logging.sinks.list", "logging.sinks.get", "logging.sinks.create", "logging.sinks.update", "logging.sinks.delete", "resourcemanager.projects.getIamPolicy", "resourcemanager.organizations.getIamPolicy", "iam.serviceAccounts.get", "iam.workloadIdentityPoolProviders.get"]
  stage = "ALPHA"
}

resource "google_organization_iam_binding" "containers_service_account_custom_role_binding" {
  role = google_organization_iam_custom_role.containers_iam_role.id
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_service_account.email}"]
}

resource "google_organization_iam_binding" "containers_organization_role_binding" {
  role = "roles/container.admin"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_service_account.email}"]
}

resource "google_organization_iam_binding" "containers_organization_role_binding2" {
  role = "roles/pubsub.admin"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_service_account.email}"]
}

resource "google_service_account_iam_binding" "containers_workload_assignment" {
  service_account_id = google_service_account.containers_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_organization_iam_binding" "cloud_logs_account_organization_role_binding" {
  role = "roles/pubsub.publisher"
  org_id = var.org_id
  members = ["serviceAccount:cloud-logs@system.gserviceaccount.com"]
}

resource "google_service_account" "containers_data_collection_service_account" {
  account_id = "ms-defender-containers-stream"
  display_name = "Microsoft Defender Data Collector"
  project = google_project.mgmt_project.project_id
}

resource "google_organization_iam_custom_role" "containers_data_collection_iam_role" {
  role_id = "MicrosoftDefenderContainersDataCollectionRole"
  title = "Microsoft Defender Containers Data Collection Custom Role"
  org_id = var.org_id
  description = "Microsoft Defender Containers Data Collection Custom Role."
  permissions = ["pubsub.subscriptions.consume", "pubsub.subscriptions.get"]
  stage = "ALPHA"
}

resource "google_organization_iam_binding" "containers_data_collection_organization_role_binding" {
  role = google_organization_iam_custom_role.containers_data_collection_iam_role.id
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.containers_data_collection_service_account.email}"]
}

resource "google_service_account_iam_binding" "containers_data_collection_workload_assignment" {
  service_account_id = google_service_account.containers_data_collection_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "containers_data_collection_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.containers_data_collection_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for Containers Data Collection."
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://2041288c-b303-4ca0-9076-9612db3beeb2"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}

resource "google_organization_iam_audit_config" "organization_k8s_audit_log_config" {
    org_id = var.org_id
    service = "container.googleapis.com"
    audit_log_config {
        log_type = "ADMIN_READ"
    }
    audit_log_config {
        log_type = "DATA_READ"
    }
    audit_log_config {
        log_type = "DATA_WRITE"
    }
}

resource "google_service_account" "mdfs_service_account" {
  account_id = "microsoft-defender-for-servers"
  display_name = "Microsoft Defender for Servers"
  project = google_project.mgmt_project.project_id
}

resource "google_service_account_iam_binding" "mdfs_workload_assignment" {
  service_account_id = google_service_account.mdfs_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "defender_for_servers_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.servers_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for Defender for Servers."
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://AzureSecurityCenter.MultiCloud.DefenderForServers"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}


resource "google_service_account" "db_arc_ap_service_account" {
  account_id = "microsoft-databases-arc-ap"
  display_name = "Microsoft Defender for Databases ARC auto provisioning"
  project = google_project.mgmt_project.project_id
}

resource "google_service_account_iam_binding" "arc_ap_workload_assignment" {
  service_account_id = google_service_account.db_arc_ap_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "arc_ap_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.databases_arc_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for Defender for databases."
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://AzureSecurityCenter.MultiCloud.DefenderForServers"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}

resource "google_organization_iam_binding" "arc_ap_organization_role_binding" {
  role = "roles/compute.viewer"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.mdfs_service_account.email}", "serviceAccount:${google_service_account.db_arc_ap_service_account.email}"]
}

resource "google_organization_iam_binding" "arc_ap_organization_role_binding_2" {
  role = "roles/osconfig.osPolicyAssignmentAdmin"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.mdfs_service_account.email}", "serviceAccount:${google_service_account.db_arc_ap_service_account.email}"]
}

resource "google_organization_iam_binding" "arc_ap_organization_role_binding_3" {
  role = "roles/osconfig.osPolicyAssignmentReportViewer"
  org_id = var.org_id
  members = ["serviceAccount:${google_service_account.mdfs_service_account.email}", "serviceAccount:${google_service_account.db_arc_ap_service_account.email}"]
}

resource "google_organization_iam_custom_role" "data_sensitivity_iam_role" {
  role_id = "MDCDataSecurityPostureStorageRole"
  title = "MDC Data Security Posture Storage"
  org_id = var.org_id
  description = "Microsoft Defender CSPM Data Security Posture Storage Role"
  permissions = ["storage.objects.list", "storage.objects.get", "storage.buckets.get"]
}

resource "google_service_account" "data_sensitivity_service_account" {
  account_id = "mdc-data-sec-posture-storage"
  display_name = "Microsoft Defender Data Security Posture Storage"
  project = google_project.mgmt_project.project_id
}

resource "google_organization_iam_binding" "data_sensitivity_organization_role_binding" {
  org_id = var.org_id
  role = google_organization_iam_custom_role.data_sensitivity_iam_role.id
  members = ["serviceAccount:${google_service_account.data_sensitivity_service_account.email}"]
}

resource "google_service_account_iam_binding" "data_sensitivity_workload_assignment" {
  service_account_id = google_service_account.data_sensitivity_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "data_sensitivity_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.data_sensitivity_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for Microsoft Defender Data Security Posture Storage"
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["api://2723a073-e7ed-4ff8-be05-88acda0c702e"]
    issuer_uri        = "https://sts.windows.net/${var.mdc_tenant_id}"
  }
}


resource "google_organization_iam_custom_role" "agentless_scanning_iam_role" {
  role_id = "MDCAgentlessScanningRole"
  title = "MDC Agentless Scanning Role"
  org_id = var.org_id
  description = "Permissions for agentless disk scanning"
  permissions = ["compute.disks.createSnapshot", "compute.instances.get"]
}

resource "google_organization_iam_binding" "agentless_scanning_organization_role_binding" {
  org_id = var.org_id
  role = google_organization_iam_custom_role.agentless_scanning_iam_role.id
  members = ["serviceAccount:mdc-agentless-scanning@guardians-prod-diskscanning.iam.gserviceaccount.com"]
}

resource "google_organization_iam_binding" "agentless_scanning_organization_role_binding2" {
  org_id = var.org_id
  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = ["serviceAccount:service-220551266886@compute-system.iam.gserviceaccount.com"]
}

resource "google_service_account" "ciem_service_account" {
  account_id = "microsoft-defender-ciem"
  display_name = "Microsoft Defender for cloud CIEM"
  project = google_project.mgmt_project.project_id
}

resource "google_service_account_iam_binding" "ciem_workload_assignment" {
  service_account_id = google_service_account.ciem_service_account.name
  role = "roles/iam.workloadIdentityUser"
  members = ["principalSet://iam.googleapis.com/projects/${google_project.mgmt_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id}/*"]
}

resource "google_iam_workload_identity_pool_provider" "ciem_workload_identity_pool_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.mdc_workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.ciem_workload_identity_pool_provider_id
  description                        = "OIDC identity pool provider for CIEM"
  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.tid" = "assertion.tid"
    "attribute.appid" = "assertion.appid"
  }
  oidc {
    allowed_audiences = ["api://mciem-gcp-oidc-app"]
    issuer_uri        = "https://sts.windows.net/${var.workload_pool_id}"
  }
  attribute_condition = "attribute.appid=='b46c3ac5-9da6-418f-a849-0a07a10b3c6c'"
}

resource "google_organization_iam_binding" "ciem_organization_role_binding" {
  org_id = var.org_id
  role = "roles/iam.securityReviewer"
  members = ["serviceAccount:${google_service_account.ciem_service_account.email}"]
}

output "gcloud_mgmt_project_number" {
  value = google_project.mgmt_project.number
}


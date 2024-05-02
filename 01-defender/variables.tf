variable "org_id" {
  type    = string
  description = "The ID of organization in GCP"
}

variable "billing_id" {
  description = "Enter a billing account for the auto-generated management project"
  type = string
}

variable "use_least_privilege_access_permissions" {
  description = "Whether to configure Microsoft defender for cloud to use least privilege access permissions"
  type        = bool
  default     = false
}

variable "workload_pool_id" {
  description = "ID for workload identity pool (customer MS tenant id)"
  type        = string
  default     = "317e70adc4ec453a85307c844fd27554"
}

variable "auto_provisioner_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for auto provisioner"
  type        = string
  default     = "auto-provisioner"
}

variable "cspm_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for CSPM"
  type        = string
  default     = "cspm"
}

variable "containers_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for containers"
  type        = string
  default     = "containers"
}

variable "containers_data_collection_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for containers data collection"
  type        = string
  default     = "containers-streams"
}

variable "servers_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for defender for servers"
  type        = string
  default     = "defender-for-servers"
}

variable "databases_arc_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for defender for databases"
  type        = string
  default     = "defender-for-databases-arc-ap"
}

variable "data_sensitivity_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for defender for data security posture management"
  type        = string
  default     = "data-security-posture-storage"
}

variable "ciem_workload_identity_pool_provider_id" {
  description = "OIDC identity pool provider id for defender for ciem"
  type        = string
  default     = "ciem-discovery"
}

variable "enable_apis" {
  description = "Which APIs to enable for this project."
  type        = list(string)
  default     = ["cloudresourcemanager.googleapis.com","iam.googleapis.com","sts.googleapis.com","iamcredentials.googleapis.com","compute.googleapis.com","apikeys.googleapis.com","sqladmin.googleapis.com","cloudkms.googleapis.com","container.googleapis.com","osconfig.googleapis.com","containerscanning.googleapis.com","logging.googleapis.com","storage-component.googleapis.com","logging.googleapis.com","serviceusage.googleapis.com"]
}

variable "mdc_tenant_id" {
  description = "MDC Tenant ID"
  type        = string
  default     = "a9b71462-8f23-7e6d-b098-c0123456789a"
}

variable "dedicated_billable_project" {
  description = "Whether to create a dedicated billable GCP project automatically"
  type        = bool
  default     = true
}

variable "mgmt_project_id" {
  description = "Management Project id. The name assigned to the management project if decided to create dedicated billable project. The name of an existing one, if decided not to create a dedicated one"
  type        = string
  default     = "mdc-mgmt-proj-597925389594"
}
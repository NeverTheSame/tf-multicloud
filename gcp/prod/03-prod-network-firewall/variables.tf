variable "region" {
  type = string
}

variable "subnet_ip" {
  type = string
}

variable "rdp_whitelisted_ip_addresses" {
  description = "Dictionary of IP addresses for RDP ingress"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "all_traffic_whitelisted_ip_addresses" {
  description = "List of IP addresses and optional descriptions for all traffic whitelist"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "redis_whitelisted_ip_addresses" {
  description = "List of IP addresses and optional descriptions for Redis traffic whitelist"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "https_whitelisted_ip_addresses" {
  description = "List of IP addresses and optional descriptions for HTTPS traffic whitelist"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "YYY3_internal_ip" {
  type = string
}

variable "automatic_server_internal_ip" {
  type = string
}

variable "YYY4_internal_ip" {
  type = string
}

variable "allow_all_traffic_for_XXX_ips_map" {
  description = "Map of IP addresses to descriptions for XXX security group"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "tcp_3389_rdp_access_XXX_map" {
  description = "Map of IP addresses to descriptions for XXX security group RDP connections"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "ig_rdp_ips" {
  description = "Map of IP addresses to descriptions for RDP connection to automatic"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "internal_ipv4_cidr" {
  type = string
}

variable "ssh_assist_whitelisted_ip_addresses" {
  description = "Map of IP addresses to descriptions for SSH connection to assist machines"
  type = list(object({
    ip          = string
    description = optional(string)
  }))
  default = []
}

variable "YYY1_internal_ip" {
  type = string
}

variable "XXX_server_internal_ip" {
  type = string
}

variable "ad_server_internal_ip" {
  type = string
}
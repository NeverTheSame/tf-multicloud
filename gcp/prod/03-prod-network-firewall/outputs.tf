output "dev_vpc" {
  value = module.vpc.network_name
}

output "module_subnetwork" {
  value = module.vpc.subnets_ids[0]
}

output "region" {
  value = module.vpc
}

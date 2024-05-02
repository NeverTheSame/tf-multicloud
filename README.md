## Introduction

This repository contains Terraform configurations for deploying infrastructure across multiple cloud providers, specifically Azure and Google Cloud Platform (GCP), with some resources managed in AWS. It primarily facilitates the setup of network, compute, IAM, and firewall configurations across development and production environments.

## Structure

The repository is organized into directories for each cloud provider and environment:

- **./azure/**: Contains configurations for Azure resources including virtual machines, networking, and identity management.
- **./gcp/**: Organized into subdirectories for each GCP project component, including compute instances, networking, IAM, and other cloud services.
- **./aws/**: Houses configurations for AWS, focusing on IAM roles, network security, and compute resources.

Each subdirectory contains specific Terraform files (`*.tf`) for defining resources, along with `backend.tf` for state management and `variables.tf` for input variables.

## Key Components

### Azure Infrastructure

- **Virtual Machines**: Defined in `./azure/compute.tf`, including an Ansible server configured on Ubuntu 18.04 LTS.
- **Networking**: Setup in `./azure/network.tf`, creating a virtual network and subnets.
- **Resource Groups and Identity**: Managed within `./azure/rg.tf` and related IAM configurations.

### GCP Infrastructure

- **Compute Instances**: Configurations in `./gcp/prod/` for various environments, e.g., Ansible servers and Kubernetes clusters.
- **Networking and Firewall**: Defined across multiple directories like `./gcp/prod/03-prod-network-firewall/` to handle VPC setups and strict firewall rules.
- **IAM and Security**: Managed in directories like `./gcp/prod/02-prod-iam/`, setting up service accounts and custom IAM roles for security compliance.

### AWS Infrastructure

- **IAM**: Roles and policies for resource access defined in `./aws/prod/01-iam/`.
- **Networking and Security**: Setup in `./aws/prod/02-networking-security/`, including VPCs, subnets, and security groups.
- **Compute**: EC2 instances configured in `./aws/prod/03-compute/`, with detailed networking and EBS volumes.

## Prerequisites

- Terraform installed on your local machine.
- Access credentials configured for each cloud provider (Azure, GCP, AWS).
- Basic understanding of Terraform modules, providers, and state management.

## Usage

1. **Initialization**:
   Navigate to the specific directory for a cloud provider and environment, then run:
   ```
   terraform init
   ```
   This will initialize the Terraform configuration by downloading necessary providers and initializing backend state management.

2. **Planning**:
   Execute the following to see the planned changes:
   ```
   terraform plan
   ```
   Review the output to understand what resources Terraform will create, modify, or destroy.

3. **Application**:
   Apply the configuration to create the resources:
   ```
   terraform apply
   ```
   Confirm the action when prompted to proceed with the resource creation.

## Best Practices

- **Version Control**: Keep your Terraform configurations in version-controlled repositories.
- **State Management**: Use remote state storage (e.g., Azure Blob Storage, GCS, AWS S3) to manage the state files securely and collaboratively.
- **Secrets Management**: Avoid committing secrets and sensitive information to your version-controlled files. Use environment variables or dedicated secrets management services.

## Security Considerations

- Ensure minimal privilege access by carefully assigning necessary permissions through IAM roles and policies.
- Regularly review security group and firewall rules to ensure they grant the least privilege necessary for operations.
- Use HTTPS for secure communication where possible, and manage SSL certificates and keys securely.
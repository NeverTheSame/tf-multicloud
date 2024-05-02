# Infrastructure AWS Project

This project sets up a Tools team infrastructure on Amazon Web Services (AWS) using Terraform. 
It's structured to manage and provision both DEV and PROD environments.

## Overview
The project is divided into two main sections:
- DEV: Sets up the AWS infrastructure for the Tools team development environment. 
It defines the VPC, subnet, security groups, and compute resources.
- PROD: Handles the creation of compute resources like EC2 instances in the Tools team production environment. 
It also manages SSH keys and IP configurations for the instances.

### DEV
#### Project Overview
This repository contains the Terraform configuration for the DEV AWS Tools team. The project is structured to manage AWS infrastructure, focusing on secrets management and compute resources. The Terraform files are organized into two main directories: 02-secrets-manager and 01-compute.
#### Directory Structure
- **02-secrets-manager**: Contains Terraform configurations for AWS Secrets Manager to securely store and manage sensitive information like credentials.
- **01-compute**: Includes Terraform files for setting up compute resources in AWS, such as EC2 instances, security groups, and networking components.

##### 02-secrets-manager
Files and Descriptions:
- secrets.tf
   - Manages AWS Secrets Manager secrets.
   - Creates a secret named 'dev-secret' to store development secrets.
   - Defines a secret version with credentials for Grafana, using Terraform variables.
- variables.tf
   - Declares variables for Grafana credentials.
   - Marks 'grafana_user' and 'grafana_password' as sensitive.
- backend.tf
   - Configures the Terraform backend to use an S3 bucket for state management.

##### 01-compute
Files and Descriptions:
- user_data.sh
   - Bash script for initializing EC2 instances.
   - Sets up SSH authorized keys, directories for various services, and installs Docker.
- data.tf
   - Defines data sources for VPC, security group, EC2 instance, and Elastic IP.
- outputs.tf
   - Outputs the public IP of the provisioned EC2 instance.
- main.tf
   - Defines resources for an EC2 instance, EBS volume, and volume attachment.
   - Configures networking and security settings.
- ssh.tf
   - Manages AWS key pairs for SSH access.
- network.tf
   - Sets up networking resources like VPC, subnet, Internet Gateway, and route tables.
- providers.tf
   - Specifies the required AWS provider and its configuration.
- security.tf
   - Defines a security group and rules for network security and traffic management.
- variables.tf
   - Declares variables for public keys, CIDR blocks, availability zone, and naming.
- backend.tf
   - Configures Terraform backend for state management in an S3 bucket.
 
#### Usage Instructions
To use these configurations:
- Ensure you have Terraform installed and AWS credentials configured.
- Clone this repository and navigate to the desired directory (02-secrets-manager or 01-compute).
- Run `terraform init` to initialize the directory.
- Configure the required variables as needed.
- Apply the configuration with `terraform apply`.

### PROD
#### Project Overview
This repository contains the Terraform configurations for the PROD EC2 project of the Tools team. It is structured to manage and provision AWS infrastructure, focusing on IAM roles, networking, security, and EC2 compute resources.

#### Directory Structure
- 01-iam: Manages IAM policies and roles.
- 02-networking-security: Contains configurations for VPC, subnets, security groups, and networking.
- 03-compute: Defines EC2 instances, associated EBS volumes, and SSH key pairs.

##### 01-iam
- providers.tf
   - Configures the AWS provider.
   - Uses AWS CLI profile prod-user.
- iam.tf
   - Defines an IAM policy for S3 bucket access.
   - Outputs the created policy ARN.
- backend.tf
   - Sets up Terraform backend using an S3 bucket.
 
##### 02-networking-security
- data.tf
   - Retrieves information about a specific Elastic IP address.
- outputs.tf
   - Outputs the IDs of the security group, subnet, and Elastic IP.
- network.tf
   - Defines resources like VPC, subnet, Internet Gateway, and routing.
- providers.tf
   - Specifies AWS provider configuration for networking and security.
- security.tf
   - Configures security groups and rules for traffic management.
- variables.tf
   - Declares variables used in networking and security configurations.
- backend.tf
   - Configures the Terraform backend for networking and security.

##### 03-compute
- user_data.sh
   - Bash script for initializing EC2 instances.
- data.tf
   - Retrieves state data from the networking-security module.
- outputs.tf
   - Outputs the public IP of the EC2 instance.
- compute.tf
   - Defines resources like EC2 instances and EBS volumes.
- ssh.tf
   - Manages SSH key pairs for EC2 instance access.
- providers.tf
   - Sets up the AWS provider for compute resources.
- variables.tf
   - Declares variables for compute configurations.
- backend.tf
   - Configures Terraform backend for compute module.
 
##### MFA.md
- Provides instructions on setting up and using Multi-Factor Authentication (MFA) with AWS CLI.

#### Usage Instructions
To use these configurations:
- Ensure you have Terraform installed and AWS credentials configured.
- Clone this repository and navigate to the desired directory (02-secrets-manager or 01-compute).
- Run `terraform init` to initialize the directory.
- Configure the required variables as needed.
- Apply the configuration with `terraform apply`.

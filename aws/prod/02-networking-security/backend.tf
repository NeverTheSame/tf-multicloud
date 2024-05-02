terraform {
  backend "s3" {
    bucket = "tf-state-serverocm-bucket"
    key    = "prod/net-security/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
  }
}
terraform {
  backend "s3" {
    bucket = "tf-state-company"
    key    = "dev/compute/terraform.tfstate"
    region = "us-east-2"
  }
}
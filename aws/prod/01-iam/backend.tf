terraform {
  backend "s3" {
    bucket = "tf-state-serverocm-bucket"
    key    = "prod/iam/terraform.tfstate"
    region = "us-east-2"
  }
}
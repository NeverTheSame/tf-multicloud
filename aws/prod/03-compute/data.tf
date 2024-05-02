data "terraform_remote_state" "net_sec_remote_data" {
  backend = "s3"

  config = {
    bucket = "tf-state-serverocm-bucket"
    key    = "prod/net-security/terraform.tfstate"
    region = "us-east-2"
  }
}
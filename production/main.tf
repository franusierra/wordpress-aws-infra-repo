
provider "aws" {
  region  = "eu-west-1"
  profile = "terraform"
}
terraform {
  backend "s3" {
    bucket = "wp-infra-backend"
    key    = "production/state"
    region = "eu-west-1"
    profile = "terraform"
  }
}
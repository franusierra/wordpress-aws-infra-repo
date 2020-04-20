
provider "aws" {
  region  = "eu-west-1"
  profile = "terraform"
}
terraform {
  backend "s3" {
    bucket = "wp-infra-backend"
    key    = "staging/state"
    region = "eu-west-1"
    profile = "terraform"
  }
}
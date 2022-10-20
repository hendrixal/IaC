terraform {
  backend "s3" {
    bucket = "sts-terraform-backend-1"
    key    = "week3/terraform.tfstate"
    region = "us-east-1"
  }
}

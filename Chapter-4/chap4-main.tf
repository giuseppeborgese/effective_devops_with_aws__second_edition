terraform {
  backend "s3" {
    bucket = "giuseppe-devops-essential-2nd"
    key = "terraform/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
provider "aws" {
  region     = "us-east-1" # North Virginia region
  shared_credentials_file = "${pathexpand("~/.aws/credentials")}"
  profile                 = "default"
}
variable "my_default_vpcid" {
  default = "vpc-3901d841"
  description = "this depends from your account change and put your personal one"
}
/*
resource "aws_security_group" "test_group" {
  name        = "myTestGroup"
  description = "This is an empty security group created with Terraform"
  vpc_id      = "${var.my_default_vpcid}"
}
*/

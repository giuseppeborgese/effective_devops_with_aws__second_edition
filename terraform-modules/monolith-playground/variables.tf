variable "my_vpc_id" {
  description = "the vpc id where to deploy the aws machine and security group"
}

variable "my_subnet" {
  description = "the public subnet id where to deploy the ec2 machine needs to be in the same vpc of my_vpc_id"
}

variable "my_ami_id" {
  description = "A Linux Amazon 2 AMI the installation script is tested for this kind of AMI"
}

variable "my_pem_keyname" {
  description = "the Pem Key Name"
}

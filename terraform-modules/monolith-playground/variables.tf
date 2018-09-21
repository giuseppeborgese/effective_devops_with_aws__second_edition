variable "my_vpc_id" {
  description = "the vpc id where to deploy the aws machine and security group"
}

variable "my_subnet" {
  description = "the public subnet id where to deploy the ec2 machine needs to be in the same vpc of my_vpc_id"
}

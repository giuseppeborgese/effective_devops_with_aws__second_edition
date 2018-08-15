variable "subnet_public" {  default = "subnet-a94cabf4" }
variable "subnet_private" { default = "subnet-54840730"}
variable "vpc_id" { default = "vpc-3901d841"}
variable "my_ami" {
  default = "ami-b70554c8"
  description = "Amazon Linux 2 AMI (HVM), SSD Volume Type"
}
variable "pem_key_name" {  default = "effectivedeops" }

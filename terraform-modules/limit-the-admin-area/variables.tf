variable "alb_arn" {
  description = "the AWS ALB ARN to associate with this waf"
}
variable "my_office_ip" {
  description = "this needs to be in format ip/subnet for example 8.8.8.8/32"
}
variable "admin_suburl" {
  default = "/wp-admin"
  description = "the sub url to protect for example in wordpress is /wp-admin don't forget the /"
}

variable "url" {
  description = "the sub url to protect"
}
variable "limit" {
  default = "2000"
  description = "number of requests to accept before drop"
}

variable "alb_arn" {
  description = "the Application Load Balancer ARN where to apply the WAF"
}

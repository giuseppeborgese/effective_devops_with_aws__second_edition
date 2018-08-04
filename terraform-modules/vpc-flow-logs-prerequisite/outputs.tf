output "rolename" {
  value = "${aws_iam_role.flow_role.name}"
}

output "cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.flow_log.arn}"
}

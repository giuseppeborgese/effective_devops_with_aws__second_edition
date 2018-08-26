resource "aws_wafregional_byte_match_set" "startrule" {
  name  = "${var.url}"

  byte_match_tuples = [
    {
      field_to_match {
        type = "URI"
      }

      text_transformation   = "LOWERCASE"
      target_string         = "/${var.url}"
      positional_constraint = "STARTS_WITH"
    },
  ]
}

resource "aws_wafregional_rate_based_rule" "wafrule" {
  name        = "${var.url}"
  metric_name = "${var.url}"

  rate_key   = "IP"
  rate_limit = "${var.limit}"

  predicate {
    data_id = "${aws_wafregional_byte_match_set.startrule.id}"
    negated = false
    type    = "ByteMatch"
  }
}

resource "aws_wafregional_web_acl" "waf_acl" {
  depends_on  = ["aws_wafregional_byte_match_set.startrule", "aws_wafregional_rate_based_rule.wafrule"]
  name        = "playground"
  metric_name = "playground"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = "${aws_wafregional_rate_based_rule.wafrule.id}"
    type     = "RATE_BASED"
  }

}

resource "aws_wafregional_web_acl_association" "my_alb" {
  resource_arn = "${var.alb_arn}"
  web_acl_id = "${aws_wafregional_web_acl.waf_acl.id}"
}

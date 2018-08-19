resource "aws_wafregional_ipset" "ipset" {
  name = "allow_ips"

  ip_set_descriptor {
    type  = "IPV4"
    value = "${var.my_office_ip}"
  }
}

resource "aws_wafregional_byte_match_set" "startrule" {
  name  = "admin"

  byte_match_tuples
    {
      field_to_match {
        type = "URI"
      }

      text_transformation   = "LOWERCASE"
      target_string         = "${var.admin_suburl}"
      positional_constraint = "STARTS_WITH"
    }
}

resource "aws_wafregional_rule" "wafrule" {
  name        = "adminrule"
  metric_name = "adminrule"

  predicate {
    type    = "IPMatch"
    data_id = "${aws_wafregional_ipset.ipset.id}"
    negated = true
  }
  predicate {
    type    = "ByteMatch"
    data_id = "${aws_wafregional_byte_match_set.startrule.id}"
    negated = false
  }

}

resource "aws_wafregional_web_acl" "waf_acl" {
  name        = "adminprotection"
  metric_name = "adminprotection"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {      type = "BLOCK" }
    priority = 1
    rule_id  = "${aws_wafregional_rule.wafrule.id}"
    type     = "REGULAR"
  }
}

resource "aws_wafregional_web_acl_association" "my_alb" {
  resource_arn = "${var.alb_arn}"
  web_acl_id = "${aws_wafregional_web_acl.waf_acl.id}"
}

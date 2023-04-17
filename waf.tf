resource "aws_wafv2_web_acl" "main" {
  name        = var.name
  description = "WAFv2 ACL for ${var.name}"

  scope = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = var.name
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"
          dynamic "rule_action_override" {
            for_each = rule.value.excluded_rules
            iterator = rao
            content {
              name = rao.value
              action_to_use {
                allow {

                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }
  tags = local.common_tags
}

resource "aws_wafv2_web_acl_association" "main" {
  count = var.associate_alb ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
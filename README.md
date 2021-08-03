# WAF v2 ACL.

This module enables WAFv2 ACL with default common rules that are intended for use with Cloudfront or Regional applications.
> :warning: Cloudfront WAFv2 ACLs must be specified in us-east-1 region.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | ARN of the ALB to be associated with the WAFv2 ACL. | `string` | `""` | no |
| <a name="input_associate_alb"></a> [associate\_alb](#input\_associate\_alb) | Whether to associate an ALB with the WAFv2 ACL. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where the WAF ACLs will be created. | `string` | n/a | yes |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | List of Managed WAF rules. | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    override_action = string<br>    excluded_rules  = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_rules": [<br>      "SizeRestrictions_BODY",<br>      "GenericLFI_BODY",<br>      "CrossSiteScripting_BODY"<br>    ],<br>    "name": "AWSManagedRulesCommonRuleSet",<br>    "override_action": "none",<br>    "priority": 0<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesAmazonIpReputationList",<br>    "override_action": "none",<br>    "priority": 1<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br>    "override_action": "none",<br>    "priority": 2<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesPHPRuleSet",<br>    "override_action": "none",<br>    "priority": 3<br>  },<br>  {<br>    "excluded_rules": [<br>      "SQLi_BODY"<br>    ],<br>    "name": "AWSManagedRulesSQLiRuleSet",<br>    "override_action": "none",<br>    "priority": 4<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesLinuxRuleSet",<br>    "override_action": "none",<br>    "priority": 5<br>  }<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the WebACL. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL. | `string` | n/a | yes |
| <a name="input_tag_application"></a> [tag\_application](#input\_tag\_application) | The short name of the application. | `string` | n/a | yes |
| <a name="input_tag_billing_ref"></a> [tag\_billing\_ref](#input\_tag\_billing\_ref) | The rolled-up reference for billing purposes. | `string` | n/a | yes |
| <a name="input_tag_cost_center"></a> [tag\_cost\_center](#input\_tag\_cost\_center) | The cost center in which the costs will be billed. | `string` | n/a | yes |
| <a name="input_tag_key_contact"></a> [tag\_key\_contact](#input\_tag\_key\_contact) | The full name of the technical lead responsible for the project. | `string` | n/a | yes |
| <a name="input_tag_parent_project"></a> [tag\_parent\_project](#input\_tag\_parent\_project) | Product tower, funding source or key area that owns this application. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | The ARN of the WAFv2 WebACL. |

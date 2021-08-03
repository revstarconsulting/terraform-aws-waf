variable "name" {
  type        = string
  description = "Name of the WebACL."
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL."

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "The scope has to be either \"CLOUDFRONT\" or \"REGIONAL\"."
  }
}

variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))
  description = "List of Managed WAF rules."
  default = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 0
      override_action = "none"
      excluded_rules = [
        "SizeRestrictions_BODY",  # Causes issues with file uploads in PHP/Laravel
        "GenericLFI_BODY",        # Causes issues with file uploads in PHP/Laravel
        "CrossSiteScripting_BODY" # Causes issues with file uploads in PHP/Laravel
      ]
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 1
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 2
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesPHPRuleSet",
      priority        = 3
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 4
      override_action = "none"
      excluded_rules = [
        "SQLi_BODY" # Causes issues with file uploads in PHP/Laravel
      ]
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 5
      override_action = "none"
      excluded_rules  = []
    }
  ]
}

variable "associate_alb" {
  type        = bool
  description = "Whether to associate an ALB with the WAFv2 ACL."
  default     = false
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment where the WAF ACLs will be created."
}

variable "tag_parent_project" {
  description = "Product tower, funding source or key area that owns this application."
  type        = string

  validation {
    condition = ((length(var.tag_parent_project) > 0 && length(var.tag_parent_project) <= 2048) &&
    can(regex("\\w+([\\s-_]\\w+)*", var.tag_parent_project)))
    error_message = "Must contain at least one alphanumeric character. Whitespace characters, underscores and dash are allowed inside the string."
  }
}

variable "tag_application" {
  description = "The short name of the application."
  type        = string

  validation {
    condition = ((length(var.tag_application) > 0 && length(var.tag_application) <= 2048) &&
    can(regex("\\w+([\\s-_]\\w+)*", var.tag_application)))
    error_message = "Must contain at least one alphanumeric character. Whitespace characters, underscores and dash are allowed inside the string."
  }
}

variable "tag_cost_center" {
  description = "The cost center in which the costs will be billed."
  type        = string

  validation {
    condition = ((length(var.tag_cost_center) > 0 && length(var.tag_cost_center) <= 15) &&
    can(regex("^[0-9]*$", var.tag_cost_center)))
    error_message = "Must contain only numeric characters with max length of 15."
  }
}

variable "tag_billing_ref" {
  description = "The rolled-up reference for billing purposes."
  type        = string

  validation {
    condition = ((length(var.tag_billing_ref) > 0 && length(var.tag_billing_ref) <= 2048) &&
    can(regex("\\w+([\\s-_]\\w+)*", var.tag_billing_ref)))
    error_message = "Must contain at least one alphanumeric character. Whitespace characters, underscores and dash are allowed inside the string."
  }
}

variable "tag_key_contact" {
  description = "The full name of the technical lead responsible for the project."
  type        = string

  validation {
    condition = ((length(var.tag_key_contact) > 0 &&
      length(var.tag_key_contact) <= 2048) &&
    can(regex("[\\/\\w]+([\\s-_][\\/\\w]+)*", var.tag_key_contact)))
    error_message = "Must contain at least one alphanumeric character. Whitespace characters, underscores, dash and forward slashes are allowed inside the string."
  }
}

locals {
  common_tags = {
    Parent_Project = var.tag_parent_project
    Application    = var.tag_application
    Cost_Center_ID = var.tag_cost_center
    environment    = var.environment
    Key_Contact    = var.tag_key_contact
  }
}
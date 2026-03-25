variable "create" {
  description = "Determines whether the AMP resources will be created"
  type        = bool
  default     = true
}

variable "region" {
  description = "AWS region where the resources will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all AMP resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Workspace
################################################################################

variable "create_workspace" {
  description = "Determines whether to create a new AMP workspace"
  type        = bool
  default     = true
}

variable "workspace_alias" {
  description = "Friendly name for the AMP workspace"
  type        = string
  default     = null
}

variable "retention_period_in_days" {
  description = "Number of days to retain metric data in the workspace"
  type        = number
  default     = null
}

################################################################################
# Resource Policy
################################################################################

variable "create_resource_policy" {
  description = "Controls whether a resource policy is created for the AMP workspace"
  type        = bool
  default     = true
}

variable "resource_policy_statements" {
  description = "Optional custom resource policy statements. Leave null to use the upstream defaults for same-account EKS writes and Managed Grafana reads."
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string, "Allow")
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = null
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "cloudwatch_log_group_name" {
  description = "Custom name for the AMP CloudWatch log group"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain AMP CloudWatch log events"
  type        = number
  default     = 30
}

################################################################################
# Alert Manager
################################################################################

variable "create_alert_manager" {
  description = "Controls whether an Alert Manager definition is created along with the AMP workspace"
  type        = bool
  default     = true
}

variable "approvals_required" {
  default     = 1
  description = "The minimum number of approvals required for MRs"
  type        = number
}

variable "author_email_regex" {
  default     = null
  description = "All commit author emails must match this regex"
  type        = string
}

variable "container_registry_enabled" {
  default     = true
  description = "Enable container registry for the project"
  type        = bool
}

variable "default_branch" {
  default     = "master"
  description = "The default branch for the project"
  type        = string
}

variable "description" {
  description = "A short description of the project"
  type        = string

  validation {
    condition     = can(tostring(var.description))
    error_message = "Provided description is invalid."
  }
}

variable "name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = can(regex("[[:graph:]]", var.name))
    error_message = "Provided name has invalid characters."
  }
}

variable "namespace_id" {
  description = "The group where the project belongs to"
  type        = string
}

variable "pipelines_enabled" {
  default     = true
  description = "Enable pipelines for the project"
  type        = bool
}

variable "owners" {
  default     = []
  description = <<EOF
A list of specific User IDs allowed to approve Merge Requests. Please refer to [Gitlab documentation](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/index.html) for further information
EOF
  type        = list(string)

  validation {
    condition     = can([for o in var.owners : tonumber(o)])
    error_message = "Invalid User ID provided."
  }
}

variable "tags" {
  default     = []
  description = "The list of tags to be attached to the project"
  type        = list(string)
}

variable "template_project_id" {
  default     = null
  description = <<EOF
Project ID of a custom project template. Please refer to [Gitlab documentation](https://docs.gitlab.com/ee/user/group/custom_project_templates.html) for further information
EOF
  type        = number
}

variable "use_custom_template" {
  default     = false
  description = "Use either custom instance or group project template"
  type        = bool
}

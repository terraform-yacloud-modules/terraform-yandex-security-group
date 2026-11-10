#
# yandex cloud coordinates
#
variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = null
}

#
# naming
#
variable "blank_name" {
  description = "Blank name which will be used for the created security group. Ignored when manage_default_security_group is true."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = ""
}

variable "labels" {
  description = "A set of labels"
  type        = map(string)
  default     = {}
}

#
# network
#
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "manage_default_security_group" {
  description = "Manage the network's default security group instead of creating a dedicated security group. Ingress and egress rules are applied inline to the default security group."
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "A map of ingress (inbound) rules for the security group. Each rule defines what traffic is allowed to enter the security group."
  type = map(object({
    protocol            = string
    description         = optional(string)
    labels              = optional(map(string))
    from_port           = optional(number)
    to_port             = optional(number)
    port                = optional(number)
    security_group_name = optional(string)
    security_group_id   = optional(string)
    predefined_target   = optional(string)
    v4_cidr_blocks      = optional(list(string))
    v6_cidr_blocks      = optional(list(string))
  }))

  default = {}

  validation {
    condition = alltrue([
      for rule_key, rule in var.ingress_rules :
      try(rule.port >= -1 && rule.port <= 65535, true) &&
      try(rule.from_port >= -1 && rule.from_port <= 65535, true) &&
      try(rule.to_port >= -1 && rule.to_port <= 65535, true) &&
      try(rule.from_port <= rule.to_port, true) &&
      (rule.port == null || (rule.from_port == null && rule.to_port == null)) &&
      (rule.from_port == null || rule.port == null) &&
      (rule.to_port == null || rule.port == null) &&
      try(alltrue([
        for cidr in rule.v4_cidr_blocks : can(cidrhost(cidr, 0))
      ]), true) &&
      contains(["TCP", "UDP", "ICMP", "ANY", "IPV6-ICMP"], rule.protocol)
    ])
    error_message = "Invalid ingress rule configuration. Check port ranges, CIDR blocks, and protocol values."
  }
}

variable "egress_rules" {
  description = "A map of egress (outbound) rules for the security group. Each rule defines what traffic is allowed to leave the security group."
  type = map(object({
    protocol            = string
    description         = optional(string)
    labels              = optional(map(string))
    from_port           = optional(number)
    to_port             = optional(number)
    port                = optional(number)
    security_group_name = optional(string)
    security_group_id   = optional(string)
    predefined_target   = optional(string)
    v4_cidr_blocks      = optional(list(string))
    v6_cidr_blocks      = optional(list(string))
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule_key, rule in var.egress_rules :
      try(rule.port >= -1 && rule.port <= 65535, true) &&
      try(rule.from_port >= -1 && rule.from_port <= 65535, true) &&
      try(rule.to_port >= -1 && rule.to_port <= 65535, true) &&
      try(rule.from_port <= rule.to_port, true) &&
      (rule.port == null || (rule.from_port == null && rule.to_port == null)) &&
      (rule.from_port == null || rule.port == null) &&
      (rule.to_port == null || rule.port == null) &&
      try(alltrue([
        for cidr in rule.v4_cidr_blocks : can(cidrhost(cidr, 0))
      ]), true) &&
      contains(["TCP", "UDP", "ICMP", "ANY", "IPV6-ICMP"], rule.protocol)
    ])
    error_message = "Invalid egress rule configuration. Check port ranges, CIDR blocks, and protocol values."
  }
}


variable "timeouts" {
  description = "Timeout settings for cluster operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

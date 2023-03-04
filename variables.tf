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
  description = "Blank name which will be used for all resources"
  type        = string
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

variable "ingress_rules" {
  description = "Ingress rules"
  type        = map(object({
    protocol            = string
    description         = optional(string)
    labels              = optional(any)
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
}

variable "egress_rules" {
  description = "Egress rules"
  type        = map(object({
    protocol            = string
    description         = optional(string)
    labels              = optional(any)
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
}

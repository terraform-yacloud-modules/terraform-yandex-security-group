output "id" {
  description = "Security group ID"
  value       = local.security_group_id
}

output "name" {
  description = "Security group name"
  value       = local.security_group.name
}

output "description" {
  description = "Security group description"
  value       = local.security_group.description
}

output "folder_id" {
  description = "Folder ID where security group is located"
  value       = local.security_group.folder_id
}

output "network_id" {
  description = "Network ID where security group is located"
  value       = local.security_group.network_id
}

output "labels" {
  description = "Security group labels"
  value       = local.security_group.labels
}

output "created_at" {
  description = "Security group creation timestamp"
  value       = local.security_group.created_at
}

output "status" {
  description = "Security group status"
  value       = local.security_group.status
}

output "default_security_group_id" {
  description = "ID of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group."
  value       = try(yandex_vpc_default_security_group.main[0].id, null)
}

output "default_security_group_name" {
  description = "Name of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group."
  value       = try(yandex_vpc_default_security_group.main[0].name, null)
}

output "default_security_group_ingress_rules" {
  description = "Ingress rules of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group."
  value       = try(yandex_vpc_default_security_group.main[0].ingress, null)
}

output "default_security_group_egress_rules" {
  description = "Egress rules of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group."
  value       = try(yandex_vpc_default_security_group.main[0].egress, null)
}

output "ingress_rules" {
  description = "Map of ingress rules with their IDs"
  value = {
    for k, rule in yandex_vpc_security_group_rule.ingress : k => {
      id                = rule.id
      description       = rule.description
      protocol          = rule.protocol
      from_port         = rule.from_port
      to_port           = rule.to_port
      port              = rule.port
      security_group_id = rule.security_group_id
      predefined_target = rule.predefined_target
      v4_cidr_blocks    = rule.v4_cidr_blocks
      v6_cidr_blocks    = rule.v6_cidr_blocks
      labels            = rule.labels
    }
  }
}

output "egress_rules" {
  description = "Map of egress rules with their IDs"
  value = {
    for k, rule in yandex_vpc_security_group_rule.egress : k => {
      id                = rule.id
      description       = rule.description
      protocol          = rule.protocol
      from_port         = rule.from_port
      to_port           = rule.to_port
      port              = rule.port
      security_group_id = rule.security_group_id
      predefined_target = rule.predefined_target
      v4_cidr_blocks    = rule.v4_cidr_blocks
      v6_cidr_blocks    = rule.v6_cidr_blocks
      labels            = rule.labels
    }
  }
}

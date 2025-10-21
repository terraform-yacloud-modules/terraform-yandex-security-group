output "id" {
  description = "Security group ID"
  value       = yandex_vpc_security_group.main.id
}

output "name" {
  description = "Security group name"
  value       = yandex_vpc_security_group.main.name
}

output "description" {
  description = "Security group description"
  value       = yandex_vpc_security_group.main.description
}

output "folder_id" {
  description = "Folder ID where security group is located"
  value       = yandex_vpc_security_group.main.folder_id
}

output "network_id" {
  description = "Network ID where security group is located"
  value       = yandex_vpc_security_group.main.network_id
}

output "labels" {
  description = "Security group labels"
  value       = yandex_vpc_security_group.main.labels
}

output "created_at" {
  description = "Security group creation timestamp"
  value       = yandex_vpc_security_group.main.created_at
}

output "status" {
  description = "Security group status"
  value       = yandex_vpc_security_group.main.status
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

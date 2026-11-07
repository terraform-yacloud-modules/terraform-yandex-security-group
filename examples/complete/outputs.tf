output "id" {
  description = "Security group ID"
  value       = module.sg.id
}

output "name" {
  description = "Security group name"
  value       = module.sg.name
}

output "default_security_group_id" {
  description = "ID of the managed default security group"
  value       = module.default_sg.default_security_group_id
}

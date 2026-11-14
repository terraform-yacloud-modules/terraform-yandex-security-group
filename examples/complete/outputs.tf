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

output "existing_security_group_id" {
  description = "ID of the existing security group whose rules are managed by the module"
  value       = module.existing_sg_by_id.id
}

output "existing_security_group_name" {
  description = "Name of the existing security group resolved by its name"
  value       = module.existing_sg_by_name.name
}

output "existing_security_group_description" {
  description = "Description of the existing security group read by the module"
  value       = module.existing_sg_by_id.description
}

output "existing_security_group_ingress_rules" {
  description = "Ingress rules managed on the existing security group"
  value       = module.existing_sg_by_id.ingress_rules
}

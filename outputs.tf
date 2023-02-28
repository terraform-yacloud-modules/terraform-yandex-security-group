output "id" {
  description = "Security group ID"
  value       = yandex_vpc_security_group.main.id
}

output "name" {
  description = "Security group name"
  value       = yandex_vpc_security_group.main.name
}

module "wrapper" {
  source = "../"

  for_each = var.items

  folder_id     = try(each.value.folder_id, var.defaults.folder_id, null)
  blank_name    = try(each.value.blank_name, var.defaults.blank_name, each.key)
  description   = try(each.value.description, var.defaults.description, "")
  labels        = try(each.value.labels, var.defaults.labels, {})
  vpc_id        = try(each.value.vpc_id, var.defaults.vpc_id, null)
  ingress_rules = try(each.value.ingress_rules, var.defaults.ingress_rules, {})
  egress_rules  = try(each.value.egress_rules, var.defaults.egress_rules, {})
}

data "yandex_vpc_security_group" "ingress" {
  for_each = {
    for k, v in var.ingress_rules : k => v if lookup(v, "security_group_name", null) != null
  }

  folder_id = var.folder_id
  name      = each.value["security_group_name"]
}

data "yandex_vpc_security_group" "egress" {
  for_each = {
    for k, v in var.egress_rules : k => v if lookup(v, "security_group_name", null) != null
  }

  folder_id = var.folder_id
  name      = each.value["security_group_name"]
}

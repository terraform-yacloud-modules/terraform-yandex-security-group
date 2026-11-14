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

data "yandex_vpc_security_group" "existing" {
  count = local.manage_existing_security_group ? 1 : 0

  folder_id         = var.folder_id
  security_group_id = var.existing_security_group_id
  name              = var.existing_security_group_id == null ? var.existing_security_group_name : null

  lifecycle {
    precondition {
      condition     = !var.manage_default_security_group
      error_message = "manage_existing_security_group cannot be used together with manage_default_security_group."
    }
  }
}

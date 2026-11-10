locals {
  manage_default_security_group = var.manage_default_security_group
  security_group_id             = local.manage_default_security_group ? yandex_vpc_default_security_group.main[0].id : yandex_vpc_security_group.main[0].id
}

resource "yandex_vpc_security_group" "main" {
  count = local.manage_default_security_group ? 0 : 1

  name        = var.blank_name
  description = var.description
  folder_id   = var.folder_id
  labels      = var.labels
  network_id  = var.vpc_id


  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}

resource "yandex_vpc_default_security_group" "main" {
  count = local.manage_default_security_group ? 1 : 0

  network_id  = var.vpc_id
  description = var.description
  labels      = var.labels

  dynamic "ingress" {
    for_each = { for k, v in var.ingress_rules : k => v if local.manage_default_security_group }
    content {
      protocol          = ingress.value["protocol"]
      description       = try(ingress.value["description"], null)
      labels            = try(ingress.value["labels"], null)
      from_port         = try(ingress.value["from_port"], null)
      to_port           = try(ingress.value["to_port"], null)
      port              = try(ingress.value["port"], null)
      security_group_id = lookup(ingress.value, "security_group_name", null) != null ? data.yandex_vpc_security_group.ingress[ingress.key].id : try(ingress.value["security_group_id"], null)
      predefined_target = try(ingress.value["predefined_target"], null)
      v4_cidr_blocks    = try(ingress.value["v4_cidr_blocks"], null)
      v6_cidr_blocks    = try(ingress.value["v6_cidr_blocks"], null)
    }
  }

  dynamic "egress" {
    for_each = { for k, v in var.egress_rules : k => v if local.manage_default_security_group }
    content {
      protocol          = egress.value["protocol"]
      description       = try(egress.value["description"], null)
      labels            = try(egress.value["labels"], null)
      from_port         = try(egress.value["from_port"], null)
      to_port           = try(egress.value["to_port"], null)
      port              = try(egress.value["port"], null)
      security_group_id = lookup(egress.value, "security_group_name", null) != null ? data.yandex_vpc_security_group.egress[egress.key].id : try(egress.value["security_group_id"], null)
      predefined_target = try(egress.value["predefined_target"], null)
      v4_cidr_blocks    = try(egress.value["v4_cidr_blocks"], null)
      v6_cidr_blocks    = try(egress.value["v6_cidr_blocks"], null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}

resource "yandex_vpc_security_group_rule" "ingress" {
  for_each = { for k, v in var.ingress_rules : k => v if !local.manage_default_security_group }

  security_group_binding = local.security_group_id
  direction              = "ingress"
  protocol               = each.value["protocol"]
  description            = each.value["description"]
  labels                 = each.value["labels"]
  from_port              = each.value["from_port"]
  to_port                = each.value["to_port"]
  port                   = each.value["port"]
  security_group_id      = lookup(each.value, "security_group_name", null) != null ? data.yandex_vpc_security_group.ingress[each.key].id : each.value["security_group_id"]
  predefined_target      = each.value["predefined_target"]
  v4_cidr_blocks         = each.value["v4_cidr_blocks"]
  v6_cidr_blocks         = each.value["v6_cidr_blocks"]


  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}

resource "yandex_vpc_security_group_rule" "egress" {
  for_each = { for k, v in var.egress_rules : k => v if !local.manage_default_security_group }

  security_group_binding = local.security_group_id
  direction              = "egress"
  protocol               = each.value["protocol"]
  description            = each.value["description"]
  labels                 = each.value["labels"]
  from_port              = each.value["from_port"]
  to_port                = each.value["to_port"]
  port                   = each.value["port"]
  security_group_id      = lookup(each.value, "security_group_name", null) != null ? data.yandex_vpc_security_group.egress[each.key].id : each.value["security_group_id"]
  predefined_target      = each.value["predefined_target"]
  v4_cidr_blocks         = each.value["v4_cidr_blocks"]
  v6_cidr_blocks         = each.value["v6_cidr_blocks"]


  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}

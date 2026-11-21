# Yandex Cloud Security Group Terraform module

Terraform module which creates Yandex Cloud security group resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-security-group/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

## Описание

Модуль создаёт группы безопасности Yandex Cloud и управляет их правилами. Режим работы задаётся параметрами:

- **создание новой группы** — режим по умолчанию: имя задаётся в `blank_name`, сеть — в `vpc_id`, правила — в `ingress_rules` и `egress_rules`;
- **правила существующей группы** — `manage_existing_security_group = true` вместе с `existing_security_group_id` или `existing_security_group_name`; модуль управляет только правилами и не меняет описание и метки группы;
- **группа безопасности по умолчанию** — `manage_default_security_group = true`; правила применяются напрямую к default-группе сети;
- **несколько групп за один вызов** — `security_groups`: map групп, у каждой своё имя, описание, метки и наборы правил.

### Создание нескольких групп одной конфигурацией

Параметр `security_groups` позволяет описать несколько групп безопасности и их правила в одном вызове модуля:

```hcl
module "sg" {
  source = "../../"

  vpc_id = module.network.vpc_id

  security_groups = {
    frontend = {
      name = "frontend-sg"
      ingress_rules = {
        http = {
          protocol       = "TCP"
          port           = 80
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    backend = {
      name = "backend-sg"
      ingress_rules = {
        postgres = {
          protocol       = "TCP"
          port           = 5432
          v4_cidr_blocks = ["10.0.0.0/8"]
        }
      }
    }
  }
}
```

Ключи групп и ключи правил внутри групп можно выбирать произвольно. Правило, которое ссылается на другую группу, задаётся через `security_group_id` или `security_group_name`; имя ищется в каталоге `folder_id`. Каждое правило создаётся отдельным ресурсом `yandex_vpc_security_group_rule`, поэтому правила можно менять и удалять по отдельности.

Выходы `security_group_ids`, `security_group_names`, `security_group_ingress_rules` и `security_group_egress_rules` возвращают созданные группы и их правила. Ключи правил в выходах имеют вид `<ключ группы>/<ключ правила>`.

Параметр `security_groups` нельзя сочетать с `manage_default_security_group`, `manage_existing_security_group`, `blank_name`, а также с `ingress_rules` и `egress_rules` верхнего уровня — правила в этом режиме задаются внутри каждой группы.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_vpc_default_security_group.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_default_security_group) | resource |
| [yandex_vpc_security_group.group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group_rule.egress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.group_egress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.group_ingress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group.egress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |
| [yandex_vpc_security_group.existing](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |
| [yandex_vpc_security_group.group_egress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |
| [yandex_vpc_security_group.group_ingress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |
| [yandex_vpc_security_group.ingress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_blank_name"></a> [blank\_name](#input\_blank\_name) | Blank name which will be used for the created security group. Ignored when manage\_default\_security\_group, manage\_existing\_security\_group or security\_groups is used. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the security group. Ignored when manage\_existing\_security\_group or security\_groups is used. | `string` | `""` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | A map of egress (outbound) rules for the security group. Each rule defines what traffic is allowed to leave the security group. | <pre>map(object({<br/>    protocol            = string<br/>    description         = optional(string)<br/>    labels              = optional(map(string))<br/>    from_port           = optional(number)<br/>    to_port             = optional(number)<br/>    port                = optional(number)<br/>    security_group_name = optional(string)<br/>    security_group_id   = optional(string)<br/>    predefined_target   = optional(string)<br/>    v4_cidr_blocks      = optional(list(string))<br/>    v6_cidr_blocks      = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_existing_security_group_id"></a> [existing\_security\_group\_id](#input\_existing\_security\_group\_id) | ID of an existing security group to manage ingress and egress rules for. Used when manage\_existing\_security\_group is true and takes precedence over existing\_security\_group\_name. Mutually exclusive with manage\_default\_security\_group. | `string` | `null` | no |
| <a name="input_existing_security_group_name"></a> [existing\_security\_group\_name](#input\_existing\_security\_group\_name) | Name of an existing security group to manage ingress and egress rules for. The group is looked up in folder\_id. Used when manage\_existing\_security\_group is true and existing\_security\_group\_id is null. Mutually exclusive with manage\_default\_security\_group. | `string` | `null` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A map of ingress (inbound) rules for the security group. Each rule defines what traffic is allowed to enter the security group. | <pre>map(object({<br/>    protocol            = string<br/>    description         = optional(string)<br/>    labels              = optional(map(string))<br/>    from_port           = optional(number)<br/>    to_port             = optional(number)<br/>    port                = optional(number)<br/>    security_group_name = optional(string)<br/>    security_group_id   = optional(string)<br/>    predefined_target   = optional(string)<br/>    v4_cidr_blocks      = optional(list(string))<br/>    v6_cidr_blocks      = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of labels. Ignored when manage\_existing\_security\_group or security\_groups is used. | `map(string)` | `{}` | no |
| <a name="input_manage_default_security_group"></a> [manage\_default\_security\_group](#input\_manage\_default\_security\_group) | Manage the network's default security group instead of creating a dedicated security group. Ingress and egress rules are applied inline to the default security group. | `bool` | `false` | no |
| <a name="input_manage_existing_security_group"></a> [manage\_existing\_security\_group](#input\_manage\_existing\_security\_group) | Manage ingress and egress rules of an existing security group instead of creating a dedicated security group. Set existing\_security\_group\_id or existing\_security\_group\_name to select the group. The module does not change the group's description or labels. | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Map of security groups to create in a single module call. Each key produces one group with its own ingress and egress rules. When set, vpc\_id is required, blank\_name, ingress\_rules and egress\_rules must not be set, and the top-level description and labels are ignored. Mutually exclusive with manage\_default\_security\_group and manage\_existing\_security\_group. | <pre>map(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    labels      = optional(map(string), {})<br/>    ingress_rules = optional(map(object({<br/>      protocol            = string<br/>      description         = optional(string)<br/>      labels              = optional(map(string))<br/>      from_port           = optional(number)<br/>      to_port             = optional(number)<br/>      port                = optional(number)<br/>      security_group_name = optional(string)<br/>      security_group_id   = optional(string)<br/>      predefined_target   = optional(string)<br/>      v4_cidr_blocks      = optional(list(string))<br/>      v6_cidr_blocks      = optional(list(string))<br/>    })), {})<br/>    egress_rules = optional(map(object({<br/>      protocol            = string<br/>      description         = optional(string)<br/>      labels              = optional(map(string))<br/>      from_port           = optional(number)<br/>      to_port             = optional(number)<br/>      port                = optional(number)<br/>      security_group_name = optional(string)<br/>      security_group_id   = optional(string)<br/>      predefined_target   = optional(string)<br/>      v4_cidr_blocks      = optional(list(string))<br/>      v6_cidr_blocks      = optional(list(string))<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeout settings for cluster operations | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID. Required when the module creates a security group, including groups created through security\_groups. Not required when existing\_security\_group\_id or existing\_security\_group\_name is set. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Security group creation timestamp |
| <a name="output_default_security_group_egress_rules"></a> [default\_security\_group\_egress\_rules](#output\_default\_security\_group\_egress\_rules) | Egress rules of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group. |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | ID of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group. |
| <a name="output_default_security_group_ingress_rules"></a> [default\_security\_group\_ingress\_rules](#output\_default\_security\_group\_ingress\_rules) | Ingress rules of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group. |
| <a name="output_default_security_group_name"></a> [default\_security\_group\_name](#output\_default\_security\_group\_name) | Name of the managed default security group. Null when the module creates a dedicated security group or manages rules of an existing group. |
| <a name="output_description"></a> [description](#output\_description) | Security group description |
| <a name="output_egress_rules"></a> [egress\_rules](#output\_egress\_rules) | Map of egress rules with their IDs |
| <a name="output_folder_id"></a> [folder\_id](#output\_folder\_id) | Folder ID where security group is located |
| <a name="output_id"></a> [id](#output\_id) | Security group ID |
| <a name="output_ingress_rules"></a> [ingress\_rules](#output\_ingress\_rules) | Map of ingress rules with their IDs |
| <a name="output_labels"></a> [labels](#output\_labels) | Security group labels |
| <a name="output_name"></a> [name](#output\_name) | Security group name |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | Network ID where security group is located |
| <a name="output_security_group_egress_rules"></a> [security\_group\_egress\_rules](#output\_security\_group\_egress\_rules) | Egress rules of the groups created through security\_groups, keyed by "<group key>/<rule key>". Empty when security\_groups is not used. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | Map of security group keys to IDs for groups created through security\_groups. Empty when security\_groups is not used. |
| <a name="output_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#output\_security\_group\_ingress\_rules) | Ingress rules of the groups created through security\_groups, keyed by "<group key>/<rule key>". Empty when security\_groups is not used. |
| <a name="output_security_group_names"></a> [security\_group\_names](#output\_security\_group\_names) | Map of security group keys to names for groups created through security\_groups. Empty when security\_groups is not used. |
| <a name="output_status"></a> [status](#output\_status) | Security group status |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-security-group/blob/main/LICENSE).

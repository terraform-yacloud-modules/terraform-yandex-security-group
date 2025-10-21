# Yandex Cloud Security Group Terraform module

Terraform module which creates Yandex Cloud security group resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-security-group/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_security_group.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |
| [yandex_vpc_security_group_rule.egress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group_rule.ingress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule) | resource |
| [yandex_vpc_security_group.egress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |
| [yandex_vpc_security_group.ingress](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/vpc_security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blank_name"></a> [blank\_name](#input\_blank\_name) | Blank name which will be used for all resources | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | `""` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | A map of egress (outbound) rules for the security group. Each rule defines what traffic is allowed to leave the security group. | <pre>map(object({<br/>    protocol            = string<br/>    description         = optional(string)<br/>    labels              = optional(map(string))<br/>    from_port           = optional(number)<br/>    to_port             = optional(number)<br/>    port                = optional(number)<br/>    security_group_name = optional(string)<br/>    security_group_id   = optional(string)<br/>    predefined_target   = optional(string)<br/>    v4_cidr_blocks      = optional(list(string))<br/>    v6_cidr_blocks      = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | A map of ingress (inbound) rules for the security group. Each rule defines what traffic is allowed to enter the security group. | <pre>map(object({<br/>    protocol            = string<br/>    description         = optional(string)<br/>    labels              = optional(map(string))<br/>    from_port           = optional(number)<br/>    to_port             = optional(number)<br/>    port                = optional(number)<br/>    security_group_name = optional(string)<br/>    security_group_id   = optional(string)<br/>    predefined_target   = optional(string)<br/>    v4_cidr_blocks      = optional(list(string))<br/>    v6_cidr_blocks      = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of labels | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeout settings for cluster operations | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Security group creation timestamp |
| <a name="output_description"></a> [description](#output\_description) | Security group description |
| <a name="output_egress_rules"></a> [egress\_rules](#output\_egress\_rules) | Map of egress rules with their IDs |
| <a name="output_folder_id"></a> [folder\_id](#output\_folder\_id) | Folder ID where security group is located |
| <a name="output_id"></a> [id](#output\_id) | Security group ID |
| <a name="output_ingress_rules"></a> [ingress\_rules](#output\_ingress\_rules) | Map of ingress rules with their IDs |
| <a name="output_labels"></a> [labels](#output\_labels) | Security group labels |
| <a name="output_name"></a> [name](#output\_name) | Security group name |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | Network ID where security group is located |
| <a name="output_status"></a> [status](#output\_status) | Security group status |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-security-group/blob/main/LICENSE).

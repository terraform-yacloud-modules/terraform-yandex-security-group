# Wrapper for the root module

The configuration in this directory contains an implementation of a single module wrapper pattern, which allows managing several copies of a module in places where using the native Terraform 0.13+ `for_each` feature is not feasible (e.g., with Terragrunt).

You may want to use a single Terragrunt configuration file to manage multiple resources without duplicating `terragrunt.hcl` files for each copy of the same module.

This wrapper does not implement any extra functionality. It just calls the module with the same input variables and outputs the same outputs.

## Usage

### Usage with Terragrunt

`terragrunt.hcl`: 
```hcl
terraform {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-security-group//wrappers.git?ref=main"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("environment.hcl")
}

dependency "vpc" {
  config_path = "${find_in_parent_folders("vpc")}"
}

locals {
  any = ["0.0.0.0/0"]
}

inputs = {
  defaults = {
    vpc_id = dependency.vpc.outputs.vpc_id
  }
  items = {
    web = {
      description = "Web security group"
      ingress_rules = {
        http = {
          protocol       = "TCP"
          description    = "Allow HTTP traffic from the Internet"
          port           = 80
          v4_cidr_blocks = local.any
        }
        https = {
          protocol       = "TCP"
          description    = "Allow HTTPS traffic from the Internet"
          port           = 443
          v4_cidr_blocks = local.any
        }
      }
    }
  }
}
```

### Usage with Terraform

```hcl
module "security-groups" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-security-group//wrappers"
  
  defaults = {
    vpc_id = "vpc-1234567890abcdef0"
  }
  
  items = {
    web = {
      description = "Web security group"
      ingress_rules = {
        http = {
          protocol       = "TCP"
          description    = "Allow HTTP traffic from the Internet"
          port           = 80
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          protocol       = "TCP"
          description    = "Allow HTTPS traffic from the Internet"
          port           = 443
          v4_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}
```

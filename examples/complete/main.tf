data "yandex_client_config" "client" {}

provider "yandex" {
}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)

  blank_name = "vpc-complete-example"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-security-group"
    env  = "complete-example"
  }

  azs = ["ru-central1-a", "ru-central1-e", "ru-central1-d"]

  private_subnets = [["10.5.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "sg" {
  source = "../../"

  folder_id   = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  vpc_id      = module.network.vpc_id
  blank_name  = "complete-security-group"
  description = "Complete security group example with all parameters"
  labels = {
    "environment" = "test"
    "project"     = "terraform-module"
    "team"        = "devops"
  }

  ingress_rules = {
    "ssh" = {
      protocol       = "TCP"
      description    = "Allow SSH access from specific IP range"
      port           = 22
      v4_cidr_blocks = ["192.168.1.0/24"]
      labels = {
        managed_by = "terraform"
        purpose    = "ssh"
      }
    },
    "http" = {
      protocol       = "TCP"
      description    = "Allow HTTP traffic from anywhere"
      port           = 80
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
    "https" = {
      protocol       = "TCP"
      description    = "Allow HTTPS traffic from anywhere"
      port           = 443
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
    "custom-range" = {
      protocol       = "TCP"
      description    = "Allow custom port range"
      from_port      = 8000
      to_port        = 9000
      v4_cidr_blocks = ["10.0.0.0/8"]
    },
    "nlb-healthchecks" = {
      protocol          = "TCP"
      description       = "Allow load balancer health check nodes"
      predefined_target = "loadbalancer_healthchecks"
    }
  }

  egress_rules = {
    "all-outbound" = {
      protocol       = "ANY"
      description    = "Allow all outbound traffic"
      v4_cidr_blocks = ["0.0.0.0/0"]
    },
    "dns" = {
      protocol       = "UDP"
      description    = "Allow DNS queries"
      port           = 53
      v4_cidr_blocks = ["8.8.8.8/32", "8.8.4.4/32"]
    }
  }

  timeouts = {
    create = "15m"
    update = "10m"
    delete = "5m"
  }
}

module "default_sg" {
  source = "../../"

  folder_id                     = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  vpc_id                        = module.network.vpc_id
  manage_default_security_group = true
  description                   = "Default security group managed by the module"
  labels = {
    "environment" = "test"
    "project"     = "terraform-module"
    "team"        = "devops"
  }

  ingress_rules = {
    "internal-icmp" = {
      protocol       = "ICMP"
      description    = "Allow ICMP from the internal network"
      v4_cidr_blocks = ["10.0.0.0/8"]
    },
    "internal-ssh" = {
      protocol          = "TCP"
      description       = "Allow traffic between members of the default security group"
      port              = 22
      predefined_target = "self_security_group"
      labels = {
        managed_by = "terraform"
        purpose    = "ssh"
      }
    }
  }

  egress_rules = {
    "all-outbound" = {
      protocol       = "ANY"
      description    = "Allow all outbound traffic"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# Security group created outside the module. The module manages only its rules.
resource "yandex_vpc_security_group" "existing" {
  name        = "pre-existing-security-group"
  description = "Security group created outside the module"
  folder_id   = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  network_id  = module.network.vpc_id

  labels = {
    "environment" = "test"
    "project"     = "terraform-module"
  }
}

# Rules of the existing group are attached by its ID.
module "existing_sg_by_id" {
  source = "../../"

  folder_id                      = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  manage_existing_security_group = true
  existing_security_group_id     = yandex_vpc_security_group.existing.id

  ingress_rules = {
    "internal-https" = {
      protocol       = "TCP"
      description    = "Allow HTTPS from the internal network"
      port           = 443
      v4_cidr_blocks = ["10.0.0.0/8"]
      labels = {
        managed_by = "terraform"
        purpose    = "https"
      }
    }
  }

  egress_rules = {
    "internal-dns" = {
      protocol       = "UDP"
      description    = "Allow DNS queries to the internal resolvers"
      port           = 53
      v4_cidr_blocks = ["10.0.0.0/8"]
    }
  }
}

# Rules of the existing group can also be attached by its name.
module "existing_sg_by_name" {
  source = "../../"

  folder_id                      = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)
  manage_existing_security_group = true
  existing_security_group_name   = yandex_vpc_security_group.existing.name

  ingress_rules = {
    "internal-mysql" = {
      protocol       = "TCP"
      description    = "Allow MySQL from the internal network"
      port           = 3306
      v4_cidr_blocks = ["10.0.0.0/8"]
    }
  }

  depends_on = [yandex_vpc_security_group.existing]
}

data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "vpc-complete-example"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-security-group"
    env  = "complete-example"
  }

  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.5.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "sg" {
  source = "../../"

  folder_id   = data.yandex_client_config.client.folder_id
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

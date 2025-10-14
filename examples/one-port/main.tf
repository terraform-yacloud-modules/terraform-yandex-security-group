data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.4.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}


module "sg" {
  source = "../../"

  folder_id   = data.yandex_client_config.client.folder_id
  vpc_id      = module.network.vpc_id
  blank_name  = "your-security-group-name"
  description = "Your security group description"
  labels = {
    "key1" = "value1"
    "key2" = "value2"
  }

  ingress_rules = {
    "rule1" = {
      protocol       = "TCP"
      description    = "Allow TCP traffic from 0.0.0.0/0"
      port           = 80
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }

  timeouts = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

}

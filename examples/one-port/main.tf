module "sg" {
  source = "../../"

  folder_id   = "xxx"
  vpc_id      = "xxx"
  blank_name  = "your-security-group-name"
  description = "Your security group description"
  labels = {
    "key1" = "value1"
    "key2" = "value2"
  }

  ingress_rules = {
    "rule1" = {
      protocol       = "tcp"
      description    = "Allow TCP traffic from 0.0.0.0/0"
      port           = 80
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

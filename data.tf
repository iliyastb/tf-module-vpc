data "aws_caller_identity" "account" {}

data "aws_vpc" "default_vpc" {
  id = var.default_vpc_id
}
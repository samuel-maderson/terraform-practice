data "aws_subnets" "example2" {
  filter {
    name   = "vpc-id"
    values = [var.main.vpc_id]
  }
}

data "aws_subnet" "example2" {
  for_each = toset(data.aws_subnets.example2.ids)
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example2 : s.cidr_block]
}
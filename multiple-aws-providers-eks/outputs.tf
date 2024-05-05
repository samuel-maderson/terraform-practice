output "vpc_id_virginia" {
    description = "vpc id"
    value = module.vpc_virginia.vpc_id
}

output "vpc_id_oregon" {
    description = "vpc id"
    value = module.vpc_oregon.vpc_id
}
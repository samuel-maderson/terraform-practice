output "ec2_private_ip" {
    value = module.ec2_instance.private_ip
}

output "ec2_public_ip" {
    value = module.ec2_instance.public_ip
}


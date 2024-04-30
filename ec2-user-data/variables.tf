variable "project" {
  description = "main values"
  type = object({
    name = string
    environment = string
    region = string 
  })
}

variable "vpc" {
    description = "my vpc name"
    type = object({
      name = string
      cidr = string
      id = string
    })
}

variable "ec2" {
    description = "my asg name"
    type = object({
      instance_type = string
      ami_name = string
      ami_owner = string
      ec2_ni_private_subnet = string
      ec2_ni_public_subnet = string
      user_data = string
    })
}
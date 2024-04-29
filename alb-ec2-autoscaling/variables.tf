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
      cidr = string
      private_subnets = list(string)
      public_subnets = list(string)
    })
}

variable "asg" {
    description = "my asg name"
    type = object({
      min_size = number
      max_size = number
      desired_capacity = number
      instance_type = string
      ami_pattern = string
      ami_owner = string
    })
}
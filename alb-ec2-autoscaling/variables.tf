variable "project" {
  description = "main values"
  type = object({
    name = string
    environment = string
    region = string 
  })
}

variable "vpc_name" {
    description = "my vpc name"
    type = string
}

variable "cidr" {
    description = "my cidr"
    type = string
}

variable "instance_type" {
    description = "my instance type"
    type = string
}

variable "private_subnets" {
    description = "my private subnets"
    type = list(string)
}

variable "public_subnets" {
    description = "my public subnets"
    type = list(string)
}

variable "ami_pattern" {
    description = "Pattern to search AMI"
    type = string
}

variable "ami_owner" {
    description = "Owner of the AMI"
    type = string
    default = "amazon"

}

variable "aws_region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

# variable "security_group_ingress_rules" {
#   description = "group of all ingress rules"
#   type = list(object({
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = list(string)
#   }
# }
variable "project" {
  type = object({
    vpc_id = string
    region = string
    name = string
    env = string
  })
}

variable "rds" {
  type = object({
    username = string
    instance_type = string
  })
}
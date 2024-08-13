variable "main" {
  type = object({
    vpc_id = string
    ami_name = string
    subnet_id = string
  })
}
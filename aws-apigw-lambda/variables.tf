variable "project" {
    type = object({
      name = string
    })
}

# variable "apigateway" {
#     type = object({
#       name = string
#     })
# }

variable "lambda" {
  type = object({
    name = string 
  })
}
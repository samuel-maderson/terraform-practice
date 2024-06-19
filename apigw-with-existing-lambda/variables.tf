variable "project" {
    type = object({
      name = string
      env = string
    })
}

variable "apigateway" {
    type = object({
      path = string
    })
}

variable "lambda" {
  type = object({
    name = string 
  })
}
variable "main" {
    type = object({
      region = object({
        virginia = string
        oregon = string
      })
    })
    description = "common variables"
}

variable "tags_virginia" {
    type = object({
      Name = string
      Owner = string
      Workload = string
      CreatedAt = string
      UpdatedAt = string 
    })
}

variable "tags_oregon" {
    type = object({
      Name = string
      Owner = string
      Workload = string
      CreatedAt = string
      UpdatedAt = string 
    })
}
variable project {
    description = "Terraform project for AWS"
    type = object({
        name = string
        environment = string
        vpc_id = string
        region = string
    })
}

variable rds {
    description = "RDS configuration"
    type = object({
      db_name = string
      engine = string
      engine_version = string
      instance_class = string
      allocated_storage = number
      username = string
      password = string
      parameter_group_name = string
      project = object({
        db_name = string
        db_user = string
        db_password = string
        db_user_source_host = string
      })
    })
}

variable tags {
    description = "my default tags"
    type = object({
      Name = string
      Environment = string
      Workload = string
      Owner = string
      ProvisionedBy = string
      CreatedAt = string
      UpdatedAt = string 
    })
}
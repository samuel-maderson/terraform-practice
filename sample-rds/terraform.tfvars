project = {
    name = "my-project-rds"
    environment = "dev"
    vpc_id = "vpc-0488706be498d9555"
    region = "us-east-1"
}

rds = {
    db_name = "my_rds"
    engine = "mysql"
    engine_version = "8.0"
    allocated_storage = 10
    instance_class = "db.t3.medium"
    username = "admin"
    password = "qwas123456"
    parameter_group_name = "default.mysql8.0"
}

tags = {
    Name = "my-project-rds"
    Environment = "dev"
    Workload = "my-project-rds"
    Owner = "Samuel Maderson"
    ProvisionedBy = "Terraform"
    CreatedAt = "22-05-2024"
    UpdatedAt = "22-05-2024"
}
project = {
    name = "my-project-rds"
    environment = "dev"
    vpc_id = "vpc-0488eff95974f82e9"
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
    project = {
        db_name = "worker_db"
        db_user = "fulano"
        db_user_source_host = "%"
        db_password = "worker123@"
    }
}

tags = {
    Name = "my-project-rds"
    Environment = "dev"
    Workload = "my-project-rds"
    Owner = "Samuel Maderson"
    ProvisionedBy = "Terraform"
    CreatedAt = "25-05-2024"
    UpdatedAt = "25-05-2024"
}
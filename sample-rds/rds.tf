provider "aws" {
    region = var.project.region
}

locals {

    name = "${var.project.environment}-${var.project.name}"
    region = var.project.region
    tags = var.tags
}

data "aws_vpc" "my_vpc" {
    id = var.project.vpc_id
}

resource "aws_db_instance" "my_rds" {
    db_name = var.rds.db_name
    engine = var.rds.engine
    engine_version = var.rds.engine_version
    allocated_storage = 10
    instance_class = var.rds.instance_class
    username = var.rds.username
    password = var.rds.password
    parameter_group_name = var.rds.parameter_group_name
    publicly_accessible = true
    vpc_security_group_ids = [aws_security_group.my_db_sg.id]
}   

resource "aws_security_group" "my_db_sg" {
    name = "my_db_sg"
    vpc_id = data.aws_vpc.my_vpc.id

    ingress {
            cidr_blocks = ["0.0.0.0/0"]
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            description = "Allow MySQL"
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
        description = "Allow all outbound traffic"
    }
}
provider "aws" {
    region = var.project.region
}

data "aws_vpc" "default" {
    id = var.project.vpc_id
}

resource "aws_db_instance" "rds_ssm_secret" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.rds.instance_type
  username             = "foo"
  password             = data.aws_ssm_parameter.db_password.value
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
    name = "rds_sg"
    description = "my sg"
    vpc_id = data.aws_vpc.default.id

    ingress = [
        {
            description = "MySQL"
            from_port = 3306
            to_port = 3306
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ]

    egress = [
        {
            description = "outbound"
            from_port = 0
            to_port = 0
            protocol = -1
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ]
}

data "aws_ssm_parameter" "db_password" {
    name = "/prod/db/password"
}
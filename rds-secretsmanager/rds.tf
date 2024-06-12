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
  password             = aws_secretsmanager_secret_version.secret_version.secret_string
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

# Generate a random string to use as the secret value
resource "random_string" "secret_value" {
  length  = 20
  special = true
}

# Create a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "secret" {
  name        = "${var.project.env}-${var.project.name}"
  description = "my rds secret"
}

# Create a new secret version with the generated random value
resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = random_string.secret_value.result
}
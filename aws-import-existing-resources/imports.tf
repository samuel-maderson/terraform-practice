provider "aws" {
    region = "us-east-1"

    default_tags {
      tags = {
        Name = "Terraform"
        Environment = "dev"
        Owner = "Samuel Maderson"
      }
    }
}

import {
    to = aws_db_instance.default
    id = "my-rds-wlwl"
}

provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "region-name"
    values = [local.region]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ec2.ami_name]
  }
}

data "aws_vpc" "my_vpc" {
  id = var.vpc.id
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = var.project.region

  vpc_cidr = var.vpc.cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  user_data = filebase64(var.ec2.user_data)

  tags = {
    Name       = local.name
    Worload    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2.instance_type # used to set core count below
  availability_zone           = element(data.aws_availability_zones.available.names, 0)
  subnet_id                   = var.ec2.ec2_ni_public_subnet
  vpc_security_group_ids      = [module.security_group.security_group_id]
  disable_api_stop            = false
  associate_public_ip_address = true

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  # cpu_options = {
  #   core_count       = 2
  #   threads_per_core = 1
  # }
  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  # ebs_block_device = [
  #   {
  #     device_name = "/dev/sdf"
  #     volume_type = "gp3"
  #     volume_size = 5
  #     throughput  = 200
  #     encrypted   = true
  #     kms_key_id  = aws_kms_key.this.arn
  #     tags = {
  #       MountPoint = "/mnt/data"
  #     }
  #   }
  # ]

  tags = local.tags
}


module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "complete-sg"
  description = "Security group with all available arguments set (this is just an example)"
  vpc_id      = data.aws_vpc.my_vpc.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = local.tags
}
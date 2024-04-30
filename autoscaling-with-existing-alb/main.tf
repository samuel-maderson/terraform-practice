provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}
data "aws_ami" "my_ami" {
  most_recent = true
  owners      = [var.asg.ami_owner]

  filter {
    name   = "name"
    values = [var.asg.ami_name]
  }
}

data "aws_vpc" "selected" {
    filter {
        name = "tag:Name"
        values = [var.vpc.name]
    }
}

data "aws_subnets" "main_ones" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.selected.id]
    }

    tags = {
        Name = var.vpc.private_subnets_pattern
    }
}

data "aws_lb_target_group" "tg_test" {
    arn  = var.asg.target_group_arn
}

locals {
  name   = "${var.project.environment}-${var.project.name}"
  region = var.project.region

  # vpc_cidr = var.vpc.cidr
  # azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
      example    = local.name
      GithubRepo = "terraform-aws-vpc"
      GithubOrg  = "terraform-aws-modules"
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.4.1"
  # insert the 1 required variable here

  # Autoscaling group
  name            = "complete-${local.name}"
  use_name_prefix = false
  instance_name   = local.name

  ignore_desired_capacity_changes = true

  min_size                  = var.asg.min_size
  max_size                  = var.asg.max_size
  desired_capacity          = var.asg.desired_capacity
  wait_for_capacity_timeout = 0
  default_instance_warmup   = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.aws_subnets.main_ones.ids
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  # Traffic source attachment
  create_traffic_source_attachment = true
  traffic_source_identifier        = data.aws_lb_target_group.tg_test.arn
  traffic_source_type              = "elbv2"

  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_maintenance_policy = {
    min_healthy_percentage = 100
    max_healthy_percentage = 110
  }

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay             = 600
      checkpoint_percentages       = [35, 70, 100]
      instance_warmup              = 300
      min_healthy_percentage       = 50
      max_healthy_percentage       = 100
      auto_rollback                = true
      scale_in_protected_instances = "Refresh"
      standby_instances            = "Terminate"
      skip_matching                = false
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "complete-${local.name}"
  launch_template_description = "Complete launch template example"
  update_default_version      = true

  image_id          = data.aws_ami.my_ami.id
  instance_type     = var.asg.instance_type
#   user_data         = filebase64("scripts/user_data.sh")
  ebs_optimized     = true
  enable_monitoring = true

  create_iam_instance_profile = true
  iam_role_name               = "complete-${local.name}"
  iam_role_path               = "/ec2/"
  iam_role_description        = "Complete IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  # Security group is set on the ENIs below
  security_groups          = [module.asg_sg.security_group_id]

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

#   # enclave_options = {
#   #   enabled = true # Cannot enable hibernation and nitro enclaves on same instance nor on T3 instance type
#   # }

#   # hibernation_options = {
#   #   configured = true # Root volume must be encrypted & not spot to enable hibernation
#   # }

#   instance_market_options = {
#     market_type = "spot"
#   }

#   # license_specifications = {
#   #   license_configuration_arn = aws_licensemanager_license_configuration.test.arn
#   # }

#   maintenance_options = {
#     auto_recovery = "default"
#   }

#   metadata_options = {
#     http_endpoint               = "enabled"
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 32
#     instance_metadata_tags      = "enabled"
#   }

  network_interfaces = [
    {
      subnet_id = var.asg.ec2_ni_private_subnet
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.asg_sg.security_group_id]
    }
  ]

  
  placement = {
    availability_zone = "${local.region}b"
  }

#   tag_specifications = [
#     {
#       resource_type = "instance"
#       tags          = { WhatAmI = "Instance" }
#     },
#     {
#       resource_type = "volume"
#       tags          = merge({ WhatAmI = "Volume" })
#     },
#     {
#       resource_type = "spot-instances-request"
#       tags          = merge({ WhatAmI = "SpotInstanceRequest" })
#     }
#   ]

  tags = local.tags

  # Autoscaling Schedule
  schedules = {
    night = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "0 18 * * 1-5" # Mon-Fri in the evening
      time_zone        = "America/Sao_Paulo"
    }

    morning = {
      min_size         = 0
      max_size         = 1
      desired_capacity = 1
      recurrence       = "0 7 * * 1-5" # Mon-Fri in the morning
    }

    go-offline-to-celebrate-new-year = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      start_time       = "2031-12-31T10:00:00Z" # Should be in the future
      end_time         = "2032-01-01T16:00:00Z"
    }
  }
  # Target scaling policy schedule based on average CPU load
  scaling_policies = {
    avg-cpu-policy-greater-than-50 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 1200
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    },
    # predictive-scaling = {
    #   policy_type = "PredictiveScaling"
    #   predictive_scaling_configuration = {
    #     mode                         = "ForecastAndScale"
    #     scheduling_buffer_time       = 10
    #     max_capacity_breach_behavior = "IncreaseMaxCapacity"
    #     max_capacity_buffer          = 10
    #     metric_specification = {
    #       target_value = 32
    #       predefined_scaling_metric_specification = {
    #         predefined_metric_type = "ASGAverageCPUUtilization"
    #         resource_label         = "testLabel"
    #       }
    #       predefined_load_metric_specification = {
    #         predefined_metric_type = "ASGTotalCPUUtilization"
    #         resource_label         = "testLabel"
    #       }
    #     }
    #   }
    # }
    # request-count-per-target = {
    #   policy_type               = "TargetTrackingScaling"
    #   estimated_instance_warmup = 120
    #   target_tracking_configuration = {
    #     predefined_metric_specification = {
    #       predefined_metric_type = "ALBRequestCountPerTarget"
    #       resource_label         = "${module.alb.arn_suffix}/${module.alb.target_groups["ex_asg"].arn_suffix}"
    #     }
    #     target_value = 800
    #   }
    # }
    # scale-out = {
    #   name                      = "scale-out"
    #   adjustment_type           = "ExactCapacity"
    #   policy_type               = "StepScaling"
    #   estimated_instance_warmup = 120
    #   step_adjustment = [
    #     {
    #       scaling_adjustment          = 1
    #       metric_interval_lower_bound = 0
    #       metric_interval_upper_bound = 10
    #     },
    #     {
    #       scaling_adjustment          = 2
    #       metric_interval_lower_bound = 10
    #     }
    #   ]
    # }
  }
}


module "asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "A security group"
  vpc_id      = data.aws_vpc.selected.id

  ingress_with_cidr_blocks = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      description      = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = ["all-all"]

  tags = local.tags
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = local.name

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_security_group" "ec2_sg" {

  name        = "example"
  description = "Allows necessary ports to the ec2 instance"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}
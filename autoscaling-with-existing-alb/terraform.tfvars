project = {
    name = "terraform-practice"
    environment = "dev"
    region = "us-east-1"
}

vpc = {
    name = "project-vpc"
    private_subnets_pattern = "project-subnet-private*"
}

asg = {
    instance_type = "t3.medium"
    ami_name = "myami"
    ami_owner = "self"
    min_size = 1
    max_size = 1
    desired_capacity = 1
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:211125697579:targetgroup/tg-test2/b6ae8d47a6c1eaf6"
    ec2_ni_private_subnet = "subnet-03edd23a6f5ea9b62"
}
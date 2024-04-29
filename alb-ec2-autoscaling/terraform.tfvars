project = {
    name = "terraform-practice"
    environment = "dev"
    region = "us-east-1"
}

vpc = {
    cidr = "10.0.0.0/16"
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

asg = {
    instance_type = "t3.micro"
    ami_pattern = "al2023-ami-2023*86_64"
    ami_owner = "amazon"
    min_size = 1
    max_size = 1
    desired_capacity = 1
}

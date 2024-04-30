project = {
    name = "terraform-practice"
    environment = "dev"
    region = "us-east-1"
}

vpc = {
    name = "project-vpc"
    private_subnets_pattern = "project-subnet-private*"
    cidr = "10.0.0.0/16"
    id = "vpc-03ba55c1d8e9d2d9f"
}

ec2 = {
    instance_type = "t3.medium"
    ami_name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240423"
    ami_owner = "self"
    ec2_ni_private_subnet = "subnet-0c150093c94c045c4"
    ec2_ni_public_subnet = "subnet-0f1fd9618e4bbfa93"
    user_data = "scripts/user_data.sh"
}
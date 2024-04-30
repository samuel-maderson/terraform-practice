project = {
    name = "terraform-practice"
    environment = "dev"
    region = "us-east-1"
}

vpc = {
    name = "project-vpc"
    cidr = "10.0.0.0/16"
    id = "vpc-0eea69837956ac19a"
}

ec2 = {
    instance_type = "t3.medium"
    ami_name = "my-ami*"
    ami_owner = "self"
    ec2_ni_private_subnet = "subnet-0c150093c94c045c4"
    ec2_ni_public_subnet = "subnet-0729953ccd0884173"
    user_data = "scripts/user_data.sh"
}
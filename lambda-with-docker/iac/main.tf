data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = "590183924794.dkr.ecr.us-east-1.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name  = "my-lambda1"
  create_package = false

#   image_uri    = module.docker_image.image_uri
  image_uri    = "590183924794.dkr.ecr.us-east-1.amazonaws.com/lambda-with-docker:latest"
  package_type = "Image"
}
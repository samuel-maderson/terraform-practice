data "aws_ecr_authorization_token" "token" {}

data "aws_iam_role" "my_role" {
  name = "ROLE_TEST"
}

provider "docker" {
  registry_auth {
    address  = "${var.project.account_id}.dkr.ecr.${var.project.region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name  = var.project.function_name
  create_package = false
  attach_policy_json = true
  
  # it's just an example policy
  policy_json        = <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecr:*"
                ],
                "Resource": ["*"]
            },
             {
                "Effect": "Allow",
                "Action": [
                    "lambda:*"
                ],
                "Resource": ["*"]
            },
             {
                "Effect": "Allow",
                "Action": [
                    "cloudwatch:*"
                ],
                "Resource": ["*"]
            }
        ]
    }
  EOT

  #   image_uri    = module.docker_image.image_uri
  image_uri    = "${var.project.account_id}.dkr.ecr.${var.project.region}.amazonaws.com/${var.project.image_name}:latest"
  package_type = "Image"
}
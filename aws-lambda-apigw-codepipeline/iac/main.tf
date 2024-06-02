data "aws_ecr_authorization_token" "token" {}

# data "aws_iam_role" "my_role" {
#   name = "ROLE_TEST"
# }

provider "docker" {
  registry_auth {
    address  = "${var.project.account_id}.dkr.ecr.${var.project.region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "docker_image" "test" {
    name = "test"
    build {
        context = "../."
        tag     = ["${var.docker.ecr_repository_url}:${var.docker.docker_image_tag}"]
        build_arg = {
        foo : "zoo"
        }
        label = {
        author : "zoo"
        }
    }
}

resource  "aws_ecr_repository" "my-ecr-repo" {
    name = var.project.ecr_repo_name
    image_tag_mutability = var.ecr.image_tag_mutability
    encryption_configuration {
      kms_key = var.ecr.encryption_configuration.kms_key
    }
    image_scanning_configuration {
      scan_on_push = var.ecr.image_scanning_configuration.scan_on_push
    }
}

# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "ecr_image" {

  # Runs the build.sh script which builds the dockerfile and pushes to ecr
  provisioner "local-exec" {
    command = "bash ${path.module}/../scripts/build.sh ${var.project.account_id} ${var.docker.ecr_repository_url}:${var.docker.docker_image_tag} ${var.project.region}"
  }

  provisioner "local-exec" {
    # Waiting for the ecr image to be available
    command = "sleep 60"
  }

  depends_on = [ docker_image.test ]
}


module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name  = var.project.function_name
  create_package = false
  attach_policy_json = true
  role_name = "teste-1234"

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
  image_uri    = "${var.docker.ecr_repository_url}:latest"
  package_type = "Image"

  depends_on = [ null_resource.ecr_image ]
}
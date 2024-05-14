data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address  = "992382769667.dkr.ecr.us-east-1.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "docker_image" "test" {
    name = "test"
    build {
        context = "."
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
    name = "my-ecr-repo"
}

# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "ecr_image" {

  # Runs the build.sh script which builds the dockerfile and pushes to ecr
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/build.sh ${var.docker.ecr_repository_url}:${var.docker.docker_image_tag}"
  }

  provisioner "local-exec" {
    command = "echo \"Hello World\" > /home/samuel/terraform.txt"
  }
}


variable "project" {
    type = object({
        account_id = string
        ecr_repo_name = string
        function_name = string
        region = string
    })
}

variable "docker" {
    type = object({
        ecr_repository_url = string
        docker_image_tag   = string
    })
}

variable "ecr" {
  type = object({
    image_tag_mutability = string
    encryption_configuration = object({
       kms_key = string
    })
    image_scanning_configuration = object({
        scan_on_push = bool
    })
  })
}
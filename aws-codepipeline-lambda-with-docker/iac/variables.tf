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
variable "docker" {
    type = object({
        ecr_repository_url = string
        docker_image_tag   = string
    })
}

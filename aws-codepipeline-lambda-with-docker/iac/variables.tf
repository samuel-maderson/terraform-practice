variable "project" {
    type = object({
        account_id = string
        ecr_repo_name = string
        image_name = string
        function_name = string
        region = string
    })
}
project = {
    account_id = "572722647136"
    ecr_repo_name = "aws-lambda-apigw-codepipeline"
    function_name = "my-lambda"
    region = "us-east-1"
}

docker = {
    docker_image_tag = "latest"
    ecr_repository_url = "572722647136.dkr.ecr.us-east-1.amazonaws.com/aws-lambda-apigw-codepipeline"
}

ecr = {
    image_tag_mutability = "IMMUTABLE"
    encryption_configuration = {
        kms_key = "managed"
    }
    image_scanning_configuration = {
        scan_on_push = true
    }
}
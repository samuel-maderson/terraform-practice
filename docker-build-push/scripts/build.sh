#!/bin/bash

aws_ecr_repository_url_with_tag=$1


aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 992382769667.dkr.ecr.us-east-1.amazonaws.com

# Push image
docker push $aws_ecr_repository_url_with_tag
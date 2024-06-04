#!/bin/bash

aws_account_id=$1
aws_ecr_repository_url_with_tag=$2
aws_region=$3


aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.$aws_region.amazonaws.com

# Push image
docker push $aws_ecr_repository_url_with_tag
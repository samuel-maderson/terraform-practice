#!/bin/bash

# run example
# ./deploy.sh lambda-with-docker samuelmaderson/lambda-with-docker:latest

PROJECT_DIR="/home/samuel/github.com/samuel-maderson/lambda-with-docker"
AWS_ACCOUNT_ID="975050165152"
AWS_ECR_NAME="lambda-with-docker"
AWS_ECR_IMAGE_NAME="lambda-with-docker"
AWS_REGION="us-east-1"

DOCKER_IMAGE_ECR="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_IMAGE_NAME:latest"
# build the docker image
cd $PROJECT_DIR && docker build --platform linux/amd64 -t $DOCKER_IMAGE_ECR .

# docker tag
#cd $PROJECT_DIR && docker tag $DOCKER_IMAGE_ECR $DOCKER_ECR/$DOCKER_IMAGE_ECR

# push the docker image
cd $PROJECT_DIR && docker push $DOCKER_IMAGE_ECR

# terraform plan
cd $PROJECT_DIR/iac && terraform plan

# terraform apply
cd $PROJECT_DIR/iac && terraform apply --auto-approve
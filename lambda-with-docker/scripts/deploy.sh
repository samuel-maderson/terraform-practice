#!/bin/bash

# run example
# ./deploy.sh lambda-with-docker samuelmaderson/lambda-with-docker:latest

PROJECT_DIR="/home/samuel/github.com/samuel-maderson/lambda-with-docker"
DOCKER_IMAGE_NAME=$1
DOCKER_ECR=$2
# build the docker image
cd $PROJECT_DIR && docker build --platform linux/amd64 -t $DOCKER_IMAGE_NAME .

# docker tag
cd $PROJECT_DIR && docker tag $DOCKER_IMAGE_NAME $DOCKER_ECR/$DOCKER_IMAGE_NAME

# push the docker image
cd $PROJECT_DIR && docker push $DOCKER_ECR/$DOCKER_IMAGE_NAME

# terraform plan
cd $PROJECT_DIR/iac && terraform plan

# terraform apply
cd $PROJECT_DIR/iac && terraform apply --auto-approve
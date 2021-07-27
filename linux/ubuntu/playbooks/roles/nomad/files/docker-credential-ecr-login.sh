#!/bin/bash

echo "Logging in to ECR so we can pull some containers"

eval `aws ecr get-login --no-include-email --region us-east-1`

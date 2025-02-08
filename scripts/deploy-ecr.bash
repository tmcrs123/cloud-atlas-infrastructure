#!/bin/bash

ENVIRONMENT=${ENVIRONMENT:-test}
STACK_NAME="cloud-atlas-${ENVIRONMENT}-ecr"

echo "Deploying ECR"

aws cloudformation validate-template --template-body file://../ecr/template.yaml

aws cloudformation deploy \
  --template-file ../ecr/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying ECR"

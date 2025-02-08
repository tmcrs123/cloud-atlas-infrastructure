#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-api"

echo "Deploy API Gateway"

aws cloudformation validate-template --template-body file://../api-gateway/template.yaml

aws cloudformation deploy \
  --template-file ../api-gateway/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying API Gateway"

#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-cognito"

echo "Deploying cognito"

aws cloudformation validate-template --template-body file://../cognito/template.yaml

aws cloudformation deploy \
  --template-file ../cognito/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying cognito"

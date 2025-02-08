#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-sns"

echo "Deploying SNS"

aws cloudformation validate-template --template-body file://../sns/template.yaml

aws cloudformation deploy \
  --template-file ../sns/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying SNS"

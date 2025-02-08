#!/bin/bash

ENVIRONMENT="${1:-test}"

echo "Deploying VPC"

STACK_NAME="cloud-atlas-${ENVIRONMENT}-vpc"

aws cloudformation validate-template --template-body file://../vpc/template.yaml

aws cloudformation deploy \
  --template-file ../vpc/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying VPC"

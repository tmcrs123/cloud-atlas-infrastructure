#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-cloudwatch"

echo "Deploying cloudwatch"

aws cloudformation validate-template --template-body file://../cloudwatch/template.yaml

aws cloudformation deploy \
  --template-file ../cloudwatch/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished Deploying cloudwatch"

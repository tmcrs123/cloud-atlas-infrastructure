#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-sqs"

echo "Deploying SQS"

aws cloudformation validate-template --template-body file://../sqs/template.yaml

aws cloudformation deploy \
  --template-file ../sqs/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying SQS"

#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-S3"
echo "Deploying S3"

aws cloudformation validate-template --template-body file://../s3/template.yaml

aws cloudformation deploy \
  --template-file ../s3/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying S3"

#!/bin/bash

ENVIRONMENT="${1:-test}"

STACK_NAME="cloud-atlas-${ENVIRONMENT}-cloudfront"

echo "Deploying Cloudfront"

aws cloudformation validate-template --template-body file://../cloudfront/template.yaml

aws cloudformation deploy \
  --template-file ../cloudfront/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying Cloudfront"

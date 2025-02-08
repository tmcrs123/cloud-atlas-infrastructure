#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-secrets-manager"

echo "Deploying secrets manager"

aws cloudformation validate-template --template-body file://../secrets-manager/template.yaml

aws cloudformation deploy \
  --template-file ../secrets-manager/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished Deploying secrets manager"

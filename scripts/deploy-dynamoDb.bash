#!/bin/bash

ENVIRONMENT="${1:-test}"

echo "Deploying DynamoDb"

STACK_NAME="cloud-atlas-${ENVIRONMENT}-dynamoDb"

aws cloudformation validate-template --template-body file://../dynamo-db/template.yaml

aws cloudformation deploy \
  --template-file ../dynamo-db/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying DynamoDb"

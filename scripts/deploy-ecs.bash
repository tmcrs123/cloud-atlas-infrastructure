#!/bin/bash

ENVIRONMENT="${1:-test}"
STACK_NAME="cloud-atlas-${ENVIRONMENT}-ecs"

echo "Deploying ECS"

aws cloudformation validate-template --template-body file://../ecs/template.yaml

aws cloudformation deploy \
  --template-file ../ecs/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://../parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying ECS"

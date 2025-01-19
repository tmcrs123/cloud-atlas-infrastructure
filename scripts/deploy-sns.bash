#!/bin/bash

read -p "Enter environment (test/production) [test]: " ENVIRONMENT

ENVIRONMENT=${ENVIRONMENT:-test}

STACK_NAME="snappin-${ENVIRONMENT}-sns"

aws cloudformation validate-template --template-body file://./sns/template.yaml

aws cloudformation deploy \
  --template-file ./sns/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

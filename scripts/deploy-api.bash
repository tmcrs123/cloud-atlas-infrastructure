#!/bin/bash

read -p "Enter environment (test/production) [test]: " ENVIRONMENT
# read -p "Enter cluster name (test/production) [snappin-test]: " CLUSTER
# read -p "Enter task id " TASK_ID

ENVIRONMENT=${ENVIRONMENT:-test}
# CLUSTER=${CLUSTER:-snappin-test}

STACK_NAME="snappin-${ENVIRONMENT}-api"

# aws ecs describe-tasks --cluster ${CLUSTER} --tasks ${TASK_ID}

# aws ec2 describe-network-interfaces --network-interface-ids eni-08ec2c33ec4f7aa8a


aws cloudformation validate-template --template-body file://./api-gateway/template.yaml

aws cloudformation deploy \
  --template-file ./api-gateway/template.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://parameters.json \
  --capabilities CAPABILITY_NAMED_IAM

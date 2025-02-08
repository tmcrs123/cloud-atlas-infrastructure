#!/bin/bash
aws cloudformation validate-template --template-body file://../lambda/template-1.yaml

ENVIRONMENT="${1:-test}"

LATEST_VERSION_HANDLER=$(aws s3api list-object-versions \
  --bucket cloud-atlas-${ENVIRONMENT}-lambdas \
  --prefix message-handler.zip \
  --query 'Versions[?IsLatest].VersionId' --output text)

LATEST_VERSION_PROCESS_IMAGE=$(aws s3api list-object-versions \
  --bucket cloud-atlas-${ENVIRONMENT}-lambdas \
  --prefix process-image.zip \
  --query 'Versions[?IsLatest].VersionId' --output text)

STACK_NAME="cloud-atlas-${ENVIRONMENT}-lambda"

echo "Deploying Lambda 1"

echo "Using version ${LATEST_VERSION_HANDLER} for message handler"
echo "Using version ${LATEST_VERSION_PROCESS_IMAGE} for process image"

aws cloudformation deploy \
  --template-file ../lambda/template-1.yaml \
  --stack-name "$STACK_NAME" \
  --parameter-overrides MessageHandlerLambdaS3ObjectVersion=${LATEST_VERSION_HANDLER} ProcessImageLambdaS3ObjectVersion=${LATEST_VERSION_PROCESS_IMAGE} \
  --capabilities CAPABILITY_NAMED_IAM

echo "Finished deploying Lambda"

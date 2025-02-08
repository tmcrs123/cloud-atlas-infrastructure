if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi
aws cloudformation validate-template --template-body file://./test.yaml

ENVIRONMENT=$1

STACK_NAME="cloud-atlas-${ENVIRONMENT}"

LATEST_VERSION_HANDLER=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix message-handler.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

echo "LATEST_VERSION_HANDLER: ${LATEST_VERSION_HANDLER}"

LATEST_VERSION_PROCESS_IMAGE=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix process-image.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

echo "LATEST_VERSION_PROCESS_IMAGE: ${LATEST_VERSION_PROCESS_IMAGE}"

aws cloudformation deploy \
    --template-file ./common.yaml \
    --stack-name "cloud-atlas-common" \
    --capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy \
    --template-file ./test.yaml \
    --stack-name "$STACK_NAME" \
    --parameter-overrides MessageHandlerLambdaS3ObjectVersion=${LATEST_VERSION_HANDLER} ProcessImageLambdaS3ObjectVersion=${LATEST_VERSION_PROCESS_IMAGE} Environment=test \
    --capabilities CAPABILITY_NAMED_IAM

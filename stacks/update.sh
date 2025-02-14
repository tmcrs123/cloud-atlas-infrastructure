if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi
ENVIRONMENT=$1

aws cloudformation validate-template --template-body file://./${ENVIRONMENT}.yaml
aws cloudformation validate-template --template-body file://./common.yaml

LATEST_VERSION_HANDLER=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix message-handler.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

LATEST_VERSION_PROCESS_IMAGE=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix process-image.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

LATEST_VERSION_STOP_SERVICE=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix stop-service.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

LATEST_VERSION_CLOUDFRONT_INVALIDATION=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix create-invalidation.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

echo $LATEST_VERSION_HANDLER
echo $LATEST_VERSION_PROCESS_IMAGE
echo $LATEST_VERSION_STOP_SERVICE
echo $LATEST_VERSION_CLOUDFRONT_INVALIDATION

aws cloudformation update-stack \
    --stack-name cloud-atlas-common \
    --template-body file://./common.yaml \
    --capabilities CAPABILITY_NAMED_IAM

aws cloudformation update-stack \
    --stack-name cloud-atlas-${ENVIRONMENT} \
    --template-body file://./${ENVIRONMENT}.yaml \
    --parameters \
    ParameterKey=MessageHandlerLambdaS3ObjectVersion,ParameterValue=${LATEST_VERSION_HANDLER} \
    ParameterKey=StopServiceLambdaS3ObjectVersion,ParameterValue=${LATEST_VERSION_STOP_SERVICE} \
    ParameterKey=ProcessImageLambdaS3ObjectVersion,ParameterValue=${LATEST_VERSION_PROCESS_IMAGE} \
    ParameterKey=CreateInvalidationLambdaS3ObjectVersion,ParameterValue=${LATEST_VERSION_CLOUDFRONT_INVALIDATION} \
    ParameterKey=Environment,ParameterValue=${ENVIRONMENT} \
    --capabilities CAPABILITY_NAMED_IAM

if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi

ENVIRONMENT=$1

STACK_NAME="cloud-atlas-${ENVIRONMENT}"

aws cloudformation validate-template --template-body file://./${ENVIRONMENT}.yaml

echo "Generating key-pairs pem files for cloudfront..."

mkdir keys
openssl genrsa -out ./keys/private_${ENVIRONMENT}_key.pem 2048
openssl rsa -pubout -in ./keys/private_${ENVIRONMENT}_key.pem -out ./keys/public_${ENVIRONMENT}_key.pem

echo "Go add paste the PUBLIC_KEY in the CloudfrontKey yaml. SAVE THE FILE! When done click enter to continue"

read

Echo "Starting infrastructure deployment"

LATEST_VERSION_HANDLER=$(aws s3api list-object-versions \
    --bucket cloud-atlas-lambdas \
    --prefix message-handler.zip \
    --query 'Versions[?IsLatest].VersionId' --output text)

echo "LATEST_VERSION_HANDLER: ${LATEST_VERSION_HANDLER}"

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

echo LATEST_VERSION_PROCESS_IMAGE: ${LATEST_VERSION_PROCESS_IMAGE}
echo LATEST_VERSION_STOP_SERVICE: ${LATEST_VERSION_STOP_SERVICE}
echo LATEST_VERSION_CLOUDFRONT_INVALIDATION: ${LATEST_VERSION_CLOUDFRONT_INVALIDATION}

aws cloudformation deploy \
    --template-file ./${ENVIRONMENT}.yaml \
    --region us-east-1 \
    --stack-name ${STACK_NAME} \
    --parameter-overrides MessageHandlerLambdaS3ObjectVersion=${LATEST_VERSION_HANDLER} ProcessImageLambdaS3ObjectVersion=${LATEST_VERSION_PROCESS_IMAGE} StopServiceLambdaS3ObjectVersion=${LATEST_VERSION_STOP_SERVICE} CreateInvalidationLambdaS3ObjectVersion=${LATEST_VERSION_CLOUDFRONT_INVALIDATION} Environment=${ENVIRONMENT} \
    --capabilities CAPABILITY_NAMED_IAM

echo "Pushing cloudfront private key to secrets manager..."

aws secretsmanager put-secret-value --secret-id cloud-atlas-${ENVIRONMENT}-cloudfront-private-key --secret-string file://./keys/private_${ENVIRONMENT}_key.pem --version-stages AWSCURRENT

echo "Deleting cloudfront keys...."
rm -rf ./keys

aws codebuild start-build --project-name cloud-atlas-${ENVIRONMENT}-ui-build

echo "DONT FORGET!!!"
echo "Do you need to go and update the google maps key access configs? Has any of the cloudfront URLs changed?"
read
echo "DONE!"

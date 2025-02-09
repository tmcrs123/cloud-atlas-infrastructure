if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi
aws cloudformation validate-template --template-body file://./test.yaml

ENVIRONMENT=$1

STACK_NAME="cloud-atlas-${ENVIRONMENT}"

echo "Generating key-pairs pem files for cloudfront..."

mkdir keys
openssl genrsa -out ./keys/private_${ENVIRONMENT}_key.pem 2048
openssl rsa -pubout -in ./keys/private_${ENVIRONMENT}_key.pem -out ./keys/public_${ENVIRONMENT}_key.pem

echo "Go add paste the PUBLIC_KEY in the CloudfrontKey yaml. SAVE THE FILE! When done click enter to continue"

read

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

echo "LATEST_VERSION_PROCESS_IMAGE: ${LATEST_VERSION_PROCESS_IMAGE}"

aws cloudformation deploy \
    --template-file ./common.yaml \
    --stack-name "cloud-atlas-common" \
    --capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy \
    --template-file ./test.yaml \
    --region us-east-1 \
    --stack-name "$STACK_NAME" \
    --parameter-overrides MessageHandlerLambdaS3ObjectVersion=${LATEST_VERSION_HANDLER} ProcessImageLambdaS3ObjectVersion=${LATEST_VERSION_PROCESS_IMAGE} StopServiceLambdaS3ObjectVersion=${LATEST_VERSION_STOP_SERVICE} Environment=test \
    --capabilities CAPABILITY_NAMED_IAM

echo "Pushing cloudfront private key to secrets manager..."

aws secretsmanager put-secret-value --secret-id cloud-atlas-test-cloudfront-private-key --secret-string file://./keys/private_test_key.pem --version-stages AWSCURRENT

echo "Deleting cloudfront keys...."
rm -rf ./keys

echo "DONT FORGET!!!"
echo "Do you need to go and update the google maps key access configs? Has any of the cloudfront URLs changed?"
read
echo "Go and remove that stupid secrets manager / from TaskRole policy"
read
echo "DONE!"

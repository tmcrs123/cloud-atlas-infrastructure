# Check if environment parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi

ENVIRONMENT=$1
./deploy-vpc.bash $ENVIRONMENT - v
./deploy-dynamoDb.bash $ENVIRONMENT - v
./deploy-cloudfront.bash $ENVIRONMENT - v
./deploy-cognito.bash $ENVIRONMENT - v
./deploy-secrets-manager.bash $ENVIRONMENT - v
./deploy-sqs.bash $ENVIRONMENT - v
./deploy-sns.bash $ENVIRONMENT- v
./deploy-s3.bash $ENVIRONMENT - v

# Push lambda zip to S3 - add script
./deploy-lambda.bash $ENVIRONMENT - v
./deploy-ecr.bash $ENVIRONMENT - v
# push image to ECR
./deploy-cloudwatch.bash $ENVIRONMENT
./deploy-api.bash $ENVIRONMENT
./deploy-ecs.bash $ENVIRONMENT
# update cloudfront pk
#change endpoint in API GW integration

echo "Deployment for $ENVIRONMENT environment completed."

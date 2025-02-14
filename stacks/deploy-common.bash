aws cloudformation validate-template --template-body file://./common.yaml

aws cloudformation deploy \
    --template-file ./common.yaml \
    --stack-name cloud-atlas-common \
    --capabilities CAPABILITY_NAMED_IAM

## zip and upload lambdas
Echo "Zipping latest lambdas"

cd C:\\Users\\Admin\\Desktop\\Cloud-Atlas\\cloud-atlas-lambda\\src\\invalidation
npm run send-to-aws
cd C:\\Users\\Admin\\Desktop\\Cloud-Atlas\\cloud-atlas-lambda\\src\\message-handler
npm run send-to-aws
cd C:\\Users\\Admin\\Desktop\\Cloud-Atlas\\cloud-atlas-lambda\\src\\process-image
npm run send-to-aws
cd C:\\Users\\Admin\\Desktop\\Cloud-Atlas\\cloud-atlas-lambda\\src\\stop-service
npm run send-to-aws

Echo "Finished lambdas"

Echo "Deploying latest backend docker image to AWS"
cd C:\\Users\\Admin\\Desktop\\Cloud-Atlas\\cloud-atlas-backend
npm run send-to-aws
Echo "Finished deploying latest backend docker image to AWS"

Echo "Finished infrastructure deployment"

aws cloudformation update-stack \
    --stack-name cloud-atlas-test \
    --template-body file://./test.yaml \
    --parameters ParameterKey=MessageHandlerLambdaS3ObjectVersion,ParameterValue=Yr84NQkDSzyYjS.X_8LT9GYc5FaNffr8 ParameterKey=StopServiceLambdaS3ObjectVersion,ParameterValue=d6Jp4BSxndlIKxUDvEvaR_.eQCpWS39C ParameterKey=ProcessImageLambdaS3ObjectVersion,ParameterValue=dOMoAMcw9phqzR3n0.sf77M2O5PIqu59 ParameterKey=Environment,ParameterValue=test \
    --capabilities CAPABILITY_NAMED_IAM

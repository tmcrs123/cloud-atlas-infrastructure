if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi
ENVIRONMENT=$1

echo "starting delete of cloud-atlas-${Environment}\n"
echo "Deleting buckets\n"

aws s3 rb s3://cloud-atlas-${Environment}-dump --force --region us-east-1
aws s3 rb s3://cloud-atlas-${Environment}-optimized --force
aws s3 rb s3://cloud-atlas-${Environment}-test-ui --force

echo "Buckets delete, deleting stack..."

aws cloudformation delete-stack --stack-name cloud-atlas-${environment} --deletion-mode FORCE_DELETE_STACK

echo "Stack deleted"

echo "Press enter to delete the common stack and lambdas"
read

aws s3 rb s3://cloud-atlas-${Environment}-lambdas --force
aws cloudformation wait stack-delete-complete --stack-name cloud-atlas-${environment} --deletion-mode FORCE_DELETE_STACK

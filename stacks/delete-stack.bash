if [ -z "$1" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi
ENVIRONMENT=$1

echo "starting delete of cloud-atlas-${Environment}\n"
echo "Deleting buckets\n"

echo emptying buckets...
aws s3 rm s3://cloud-atlas-${Environment}-dump --recursive
aws s3 rm s3://cloud-atlas-${Environment}-optimized --recursive
aws s3 rm s3://cloud-atlas-${Environment}-test-ui --recursive

echo deleting buckets...
aws s3 rb s3://cloud-atlas-${Environment}-dump
aws s3 rb s3://cloud-atlas-${Environment}-optimized
aws s3 rb s3://cloud-atlas-${Environment}-test-ui

echo "Buckets delete, deleting stack..."

aws cloudformation delete-stack --stack-name cloud-atlas-${environment} --deletion-mode FORCE_DELETE_STACK

echo "Stack deleted"

echo "Press enter to delete the common stack and lambdas"
read

aws s3 rm s3://cloud-atlas-${Environment}-dump --recursive
aws s3 rb s3://cloud-atlas-${Environment}-dump

aws cloudformation wait stack-delete-complete --stack-name cloud-atlas-${environment} --deletion-mode FORCE_DELETE_STACK

echo Done

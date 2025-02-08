aws s3api list-object-versions \
    --bucket cloud-atlas-test-lambdas \
    --prefix message-handler.zip \
    --query 'Versions[?IsLatest].VersionId' --output text

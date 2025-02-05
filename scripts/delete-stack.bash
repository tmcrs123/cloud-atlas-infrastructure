#!/bin/bash

# Check if at least one stack name is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <stack-name1> <stack-name2> ... <stack-nameN>"
    exit 1
fi

# Function to delete a single stack
delete_stack() {
    local STACK_NAME=$1
    echo "Deleting CloudFormation stack: $STACK_NAME..."

    aws cloudformation delete-stack --stack-name "$STACK_NAME"

    echo "Waiting for stack $STACK_NAME deletion to complete..."
    if aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"; then
        echo "Stack $STACK_NAME deleted successfully."
    else
        echo "Failed to delete stack $STACK_NAME."
    fi
}

# Delete each stack concurrently
for STACK_NAME in "$@"; do
    delete_stack "$STACK_NAME" &
done

# Wait for all background processes to complete
wait

echo "All delete operations completed."

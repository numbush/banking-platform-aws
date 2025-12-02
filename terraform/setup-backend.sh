#!/bin/bash

#Usage: ./setup-backend.sh dev
#or ./setup-backend.sh prod

ENVIRONMENT=$1
REGION="us-east-1"
BUCKET_NAME="banking-terraform-state-${ENVIRONMENT}"
DYNAMODB_TABLE="banking-terraform-lockS-${ENVIRONMENT}"

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: ./setup-backend.sh <environment>"
    echo "Example: ./setup-backend.sh dev"
    exit 1
fi

echo "Setting up backend for ${ENVIRONMENT} in ${REGION}"

# Create S3 bucket
echo "Creating S3 bucket ${BUCKET_NAME}"
aws s3api create-bucket --bucket ${BUCKET_NAME} --region ${REGION} 2>&1 > /dev/null || echo "Bucket already exists"

# Enable versioning
echo "Enabling versioning for ${BUCKET_NAME}"
aws s3api put-bucket-encryption --bucket ${BUCKET_NAME} --region ${REGION} --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' 2>&1 > /dev/null || echo "Encryption already enabled"

# Create DynamoDB table
echo "Creating DynamoDB table ${DYNAMODB_TABLE}"
aws dynamodb create-table --table-name ${DYNAMODB_TABLE} --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST 2>&1 > /dev/null || echo "Table already exists"


echo "Backend setup complete for ${ENVIRONMENT}"
echo "S3 bucket: ${BUCKET_NAME}"
echo "DynamoDB table: ${DYNAMODB_TABLE}"
echo "Next steps:"
echo "1. Update terraform/environments/${ENVIRONMENT}/backend.tf with the correct bucket and table names"
echo "2. Run: cd terraform/environments/${ENVIRONMENT} && terraform init"
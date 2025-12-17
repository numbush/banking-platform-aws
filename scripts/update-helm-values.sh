#!/bin/bash

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"
ENVIRONMENT="dev"

echo "Updating Helm values with ECR URLs..."
echo "AWS Account ID: ${AWS_ACCOUNT_ID}"
echo "Region: ${AWS_REGION}"
echo ""

# Update accounts service
sed -i "s/<AWS_ACCOUNT_ID>/${AWS_ACCOUNT_ID}/g" helm/services/accounts/values.yaml
sed -i "s/us-east-1/${AWS_REGION}/g" helm/services/accounts/values.yaml

# Update cards service
sed -i "s/<AWS_ACCOUNT_ID>/${AWS_ACCOUNT_ID}/g" helm/services/cards/values.yaml
sed -i "s/us-east-1/${AWS_REGION}/g" helm/services/cards/values.yaml

# Update loans service
sed -i "s/<AWS_ACCOUNT_ID>/${AWS_ACCOUNT_ID}/g" helm/services/loans/values.yaml
sed -i "s/us-east-1/${AWS_REGION}/g" helm/services/loans/values.yaml

# Update gateway service
sed -i "s/<AWS_ACCOUNT_ID>/${AWS_ACCOUNT_ID}/g" helm/services/gateway/values.yaml
sed -i "s/us-east-1/${AWS_REGION}/g" helm/services/gateway/values.yaml

# Update environment chart
sed -i "s/<YOUR_AWS_ACCOUNT_ID>/${AWS_ACCOUNT_ID}/g" helm/environments/dev-env/values.yaml
sed -i "s/<AWS_ACCOUNT_ID>/${AWS_ACCOUNT_ID}/g" helm/environments/dev-env/values.yaml
sed -i "s/us-east-1/${AWS_REGION}/g" helm/environments/dev-env/values.yaml

echo "✅ Helm values updated with ECR URLs"
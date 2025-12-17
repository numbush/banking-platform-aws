#!/bin/bash

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="${AWS_REGION:-us-east-1}"
ENVIRONMENT="${ENVIRONMENT:-dev}"

ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "ECR Image URLs:"
echo "============================================"
echo "Accounts: ${ECR_REGISTRY}/banking-${ENVIRONMENT}-accounts-service:latest"
echo "Cards:    ${ECR_REGISTRY}/banking-${ENVIRONMENT}-cards-service:latest"
echo "Loans:    ${ECR_REGISTRY}/banking-${ENVIRONMENT}-loans-service:latest"
echo "Gateway:  ${ECR_REGISTRY}/banking-${ENVIRONMENT}-gateway-service:latest"
echo ""
echo "To pull images:"
echo "docker pull ${ECR_REGISTRY}/banking-${ENVIRONMENT}-accounts-service:latest"
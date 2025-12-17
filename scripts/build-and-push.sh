#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
AWS_REGION="${AWS_REGION:-us-east-1}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
VERSION="${VERSION:-v1.0.0}"

# Get AWS Account ID
echo -e "${YELLOW}Getting AWS Account ID...${NC}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo -e "${GREEN}AWS Account ID: ${AWS_ACCOUNT_ID}${NC}"
echo -e "${GREEN}ECR Registry: ${ECR_REGISTRY}${NC}"
echo -e "${GREEN}Version: ${VERSION}${NC}"
echo ""

# Login to ECR
echo -e "${YELLOW}Logging into ECR...${NC}"
aws ecr get-login-password --region ${AWS_REGION} | \
    docker login --username AWS --password-stdin ${ECR_REGISTRY}

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to login to ECR${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Successfully logged into ECR${NC}"
echo ""

# Services to build (match ECR repository names)
SERVICES=("accounts-services" "cards-services" "loans-services" "gateway-service")

# Build and push each service
for SERVICE in "${SERVICES[@]}"; do
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}Building ${SERVICE}${NC}"
    echo -e "${YELLOW}========================================${NC}"
    
    # Navigate to service directory (strip -service or -services suffix)
    SERVICE_DIR="services/${SERVICE%-service*}"
    
    if [ ! -d "$SERVICE_DIR" ]; then
        echo -e "${RED}Directory $SERVICE_DIR not found!${NC}"
        continue
    fi
    
    cd $SERVICE_DIR
    
    # Build image
    echo -e "${YELLOW}Building Docker image...${NC}"
    docker build -t ${SERVICE}:${VERSION} .
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to build ${SERVICE}${NC}"
        cd ../..
        continue
    fi
    echo -e "${GREEN}✓ Built ${SERVICE}:${VERSION}${NC}"
    
    # Tag for ECR
    ECR_REPO="${ECR_REGISTRY}/banking-${ENVIRONMENT}-${SERVICE}"
    echo -e "${YELLOW}Tagging image for ECR...${NC}"
    docker tag ${SERVICE}:${VERSION} ${ECR_REPO}:${VERSION}
    docker tag ${SERVICE}:${VERSION} ${ECR_REPO}:latest
    echo -e "${GREEN}✓ Tagged as ${ECR_REPO}:${VERSION}${NC}"
    
    # Push to ECR
    echo -e "${YELLOW}Pushing to ECR...${NC}"
    docker push ${ECR_REPO}:${VERSION}
    docker push ${ECR_REPO}:latest
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to push ${SERVICE}${NC}"
        cd ../..
        continue
    fi
    echo -e "${GREEN}✓ Pushed ${ECR_REPO}:${VERSION}${NC}"
    echo -e "${GREEN}✓ Pushed ${ECR_REPO}:latest${NC}"
    echo ""
    
    # Return to root
    cd ../..
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}All services built and pushed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Image URLs:${NC}"
for SERVICE in "${SERVICES[@]}"; do
    echo "${ECR_REGISTRY}/banking-${ENVIRONMENT}-${SERVICE}:${VERSION}"
done
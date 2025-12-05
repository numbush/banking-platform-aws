#!/bin/bash

echo "======================================"
echo "Testing EKS Cluster with Nginx"
echo "======================================"

# Create test namespace
echo "Creating test namespace..."
kubectl create namespace test-app

# Deploy nginx
echo "Deploying Nginx..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-test
  namespace: test-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: test-app
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
EOF

echo ""
echo "Waiting for LoadBalancer to be ready (this takes 2-3 minutes)..."
echo "Press Ctrl+C to stop watching once you see EXTERNAL-IP"
kubectl get svc -n test-app nginx-service --watch

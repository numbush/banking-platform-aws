# Docker Image Tags

## Current Images in ECR

| Service | Repository | Latest Tag | Date |
|---------|-----------|------------|------|
| Accounts | banking-dev-accounts-service | v1.0.0 | 2024-01-XX |
| Cards | banking-dev-cards-service | v1.0.0 | 2024-01-XX |
| Loans | banking-dev-loans-service | v1.0.0 | 2024-01-XX |
| Gateway | banking-dev-gateway-service | v1.0.0 | 2024-01-XX |

## Tagging Strategy

- `latest` - Most recent build
- `vX.Y.Z` - Semantic versioning
- `vX.Y.Z-<commit>` - Version with commit hash (future CI/CD)

## Building New Version

\`\`\`bash
export VERSION="v1.1.0"
./scripts/build-and-push.sh
\`\`\`

## Pulling Images

\`\`\`bash
# Login to ECR first
./scripts/ecr-login.sh

# Pull image
docker pull <ecr-url>/banking-dev-accounts-service:v1.0.0
\`\`\`
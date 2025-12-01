# Banking Platform on AWS EKS

![Infrastructure](https://img.shields.io/badge/infrastructure-terraform-purple)
![Deployment](https://img.shields.io/badge/deployment-gitops-blue)
![Platform](https://img.shields.io/badge/platform-AWS_EKS-orange)

Production-ready banking platform demonstrating migration from Docker Compose to AWS EKS with GitOps, security hardening, and comprehensive observability.

---

## 👔 For Recruiters & Hiring Managers

**TL;DR**: This project showcases enterprise-level DevOps transformation - migrating a legacy Docker Compose application to production-ready AWS EKS.

### Key Skills Demonstrated:

✅ **Cloud Migration** (Docker Compose → AWS EKS)  
✅ **Infrastructure as Code** (Terraform modules)  
✅ **Kubernetes Orchestration** (EKS, Helm)  
✅ **GitOps** (ArgoCD automation)  
✅ **CI/CD** (GitHub Actions)  
✅ **Security** (IRSA, External Secrets, Kyverno)  
✅ **Observability** (Prometheus + Grafana)

**Time Investment**: 6-8 weeks  
**Production Readiness**: ✅ All components production-hardened

---

## 🎯 Project Overview

### What It Does
Complete banking platform with 4 microservices:
- **Accounts Service** - Customer account management
- **Cards Service** - Credit/debit card operations
- **Loans Service** - Loan applications and tracking
- **Gateway Service** - API routing and aggregation

### The Transformation

| Aspect | Before (Docker Compose) | After (AWS EKS) |
|--------|------------------------|-----------------|
| **Deployment** | Single host | Multi-AZ EKS clusters |
| **Infrastructure** | Manual setup | Terraform IaC |
| **Secrets** | Hardcoded | AWS Secrets Manager + ESO |
| **Scaling** | Manual | HPA + Cluster Autoscaler |
| **Monitoring** | Basic logs | Prometheus + Grafana |
| **Security** | Basic | IRSA, Network Policies, Kyverno |
| **Deployment** | Manual | GitOps with ArgoCD |

---

## 📊 Platform Metrics

- **Environments**: 2 (dev, production)
- **EKS Clusters**: 2 (isolated per environment)
- **Microservices**: 4 (Python/Flask)
- **Terraform Modules**: 6 reusable modules
- **Helm Charts**: 6 charts
- **ArgoCD Applications**: 15+ applications
- **Security Policies**: Network policies + Kyverno enforcement

---

## 🏗️ Architecture

### Before: Docker Compose (Legacy)
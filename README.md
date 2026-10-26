# High-Availability Model Serving Platform: AWS ECS Fargate & Datadog IaC

[![Terraform IaC](https://img.shields.io/badge/IaC-Terraform%201.5%2B-blueviolet)](architecture/terraform)
[![Compute](https://img.shields.io/badge/Compute-AWS%20ECS%20Fargate-orange)](architecture/terraform/modules/ecs_fargate)
[![Observability](https://img.shields.io/badge/Observability-Datadog%20as%20Code-purple)](architecture/terraform/modules/datadog)
[![Revenue Impact](https://img.shields.io/badge/Production%20Scale-R%24%207M%2B%2Fmo%20Revenue-brightgreen)](README.md)

Production-grade, highly available containerized MLOps serving platform engineered to host mission-critical models driving **R$ 7M+/month** in revenue (**NTT DATA** production benchmark).

The repository migrates away from legacy barebone EC2 and CodeCommit pipelines to a modern, zero-trust infrastructure:
- **AWS ECS Fargate Cluster** behind Application Load Balancers with **Step Scaling & Target Tracking Autoscaling**.
- **Datadog Observability as Code**: Automated monitors for p95/p99 latency spikes, 5xx error rate thresholds, and Kolmogorov-Smirnov statistical feature drift.
- **GitHub Actions OIDC Workflow**: Secure CI/CD with automated Python unit tests, SAST scanning (`bandit`), and Terraform validation.

---

## 🏛️ Architecture Overview

```
[Client / API Gateway]
          │
          ▼
[Application Load Balancer]
          │
          ▼
┌────────────────────────────────────────────────────────┐
│ AWS ECS Fargate Cluster                                │
│                                                        │
│   ┌──────────────────────────┐                         │
│   │ ML Inference Task        │                         │
│   │  • FastAPI / HTTP Engine │                         │
│   │  • Datadog Agent Sidecar │                         │
│   └──────────────────────────┘                         │
│                ▲                                       │
│                │ Autoscaling Target Tracking (CPU 65%) │
│   ┌────────────┴─────────────┐                         │
│   │ Application Auto Scaling │                         │
│   └──────────────────────────┘                         │
└────────────────────────────────────────────────────────┘
          │ Traces & Metrics
          ▼
┌────────────────────────────────────────────────────────┐
│ Datadog Observability as Code                          │
│  • P99 Latency Monitor (> 150ms)                       │
│  • 5xx Error Rate Monitor (> 1%)                       │
│  • KS Feature Drift Detection                          │
└────────────────────────────────────────────────────────┘
```

---

## 🚀 Local Verification

```bash
export PYTHONPATH=src
python -m pytest tests/ -v
```

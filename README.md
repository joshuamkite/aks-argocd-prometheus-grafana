# AKS ArgoCD Prometheus Grafana

This repository contains Terraform configurations and Kubernetes manifests to set up an Azure Kubernetes Service (AKS) cluster with ArgoCD for GitOps-based deployments. It includes monitoring components including Prometheus and Grafana.

- [AKS ArgoCD Prometheus Grafana](#aks-argocd-prometheus-grafana)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [1. Deployment](#1-deployment)
    - [2. Connect to AKS Cluster](#2-connect-to-aks-cluster)
    - [3. Install ArgoCD](#3-install-argocd)
    - [4. Access ArgoCD](#4-access-argocd)
    - [6. Deploy Monitoring Stack via ApplicationSet](#6-deploy-monitoring-stack-via-applicationset)
  - [Accessing Monitoring Tools](#accessing-monitoring-tools)
    - [Prometheus](#prometheus)
    - [Grafana](#grafana)
  - [Cleanup](#cleanup)
    - [Delete ApplicationSet (optional)](#delete-applicationset-optional)
    - [Delete AKS Cluster](#delete-aks-cluster)
  - [Terraform Configuration](#terraform-configuration)
  - [ArgoCD ApplicationSet](#argocd-applicationset)
  - [Limitations](#limitations)
  - [References](#references)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)


## Overview

This project provisions:

1. An AKS cluster in Azure using Terraform using official Azure module
2. ArgoCD for GitOps-based deployments
3. Monitoring stack including:
   - Metrics Server
   - Prometheus
   - Grafana with pre-configured dashboards

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (>= 1.5.0)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) (optional)
- Azure Storage account

## Getting Started

### 1. Deployment

Deploy cluster with Terraform

### 2. Connect to AKS Cluster

Configure kubectl to connect to your AKS cluster:

```bash
az aks get-credentials --resource-group rg-terraform-azure-aks-demo-dev --name terraform-azure-aks-demo-aks
```

Verify the connection:

```bash
kubectl get nodes
```

### 3. Install ArgoCD

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd --create-namespace
```

### 4. Access ArgoCD

Get the initial admin password (**change this for production!**):

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Set up port forwarding:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

(Optional) Access ArgoCD UI at: http://localhost:8080

Login via CLI:

```bash
argocd login localhost:8080 --username admin --password <your-password> --insecure --grpc-web
```

### 6. Deploy Monitoring Stack via ApplicationSet

Apply the ApplicationSet manifest:

```bash
kubectl apply -f argocd/applicationset/monitoring-apps.yaml
```

This will deploy:
- Metrics Server
- Prometheus (kube-prometheus-stack)
- Grafana with pre-configured Prometheus datasource and Kubernetes dashboard

## Accessing Monitoring Tools

### Prometheus

Set up port forwarding:

```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 4001:9090
```

Access Prometheus at: http://127.0.0.1:4001

### Grafana

Get Grafana admin password:

```bash
# Username: admin
# Password:
kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo
```

Set up port forwarding:

```bash
kubectl port-forward service/prometheus-grafana 3000:80 --namespace monitoring
```

Access Grafana at: http://127.0.0.1:3000 (Username: `admin`)

## Cleanup

### Delete ApplicationSet (optional)

```bash
argocd appset delete monitoring-apps
```

### Delete AKS Cluster

```bash
tofu destroy
```


## Terraform Configuration

The Terraform configuration creates:
- Azure Resource Group
- AKS Cluster with:
  - Node pool with auto-scaling enabled
  - RBAC configuration
  - Azure CNI networking

## ArgoCD ApplicationSet

The ApplicationSet deploys:
- Metrics Server for basic cluster metrics
- Prometheus for comprehensive monitoring
- Grafana for visualization with pre-configured dashboards

## Limitations

- This setup is intended for development/demo purposes
- Production deployments would need additional security considerations

## References

- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.117.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | Azure/aks/azurerm | 9.4.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agents_count"></a> [agents\_count](#input\_agents\_count) | Number of agent VMs | `number` | `1` | no |
| <a name="input_agents_max_count"></a> [agents\_max\_count](#input\_agents\_max\_count) | Maximum number of agent VMs | `number` | `2` | no |
| <a name="input_agents_min_count"></a> [agents\_min\_count](#input\_agents\_min\_count) | Minimum number of agent VMs | `number` | `1` | no |
| <a name="input_agents_pool_name"></a> [agents\_pool\_name](#input\_agents\_pool\_name) | Name of the agent pool | `string` | `"nodepool"` | no |
| <a name="input_agents_size"></a> [agents\_size](#input\_agents\_size) | Size of the agent VMs | `string` | `"Standard_B2s"` | no |
| <a name="input_enable_auto_scaling"></a> [enable\_auto\_scaling](#input\_enable\_auto\_scaling) | Enable auto-scaling for the agent pool | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to apply for all resources in the stack | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_rbac_aad"></a> [rbac\_aad](#input\_rbac\_aad) | Enable RBAC AAD | `bool` | `false` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name of the storage account | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID | `string` | n/a | yes |

## Outputs

No outputs.

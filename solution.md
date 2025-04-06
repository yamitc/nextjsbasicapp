# Next.js AKS Deployment with DevSecOps Pipeline

This project demonstrates how to securely build, package, scan, and deploy a **Next.js** application to **Azure Kubernetes Service (AKS)** using a GitHub Actions pipeline. The deployment includes integration with **Azure Container Registry (ACR)**, **Helm charts**, **ingress controller**, and **security best practices**.

---

## 📌 Prerequisites

Before running the pipeline, there should be:

- An Azure subscription  
- Azure CLI installed or access to [Azure Cloud Shell](https://shell.azure.com)  
- A GitHub repository with the necessary secrets configured  

To securely deploy to Azure from GitHub Actions, the following secrets are configured in the repository under  
**Settings → Secrets and variables → Actions**:

- **`AZURE_CREDENTIALS`**  
  A JSON object containing credentials for a service principal with access to the Azure subscription.  
  Used by the `azure/login@v1` action to authenticate to Azure.  
  It includes:
  - `clientId`
  - `clientSecret`
  - `subscriptionId`
  - `tenantId`

- **`ACR_USERNAME`**  
  The username for Azure Container Registry (ACR).  
  This is typically the name of the ACR instance (e.g., `nextjsbasicapp`).

- **`ACR_PASSWORD`**  
  The password (secret) for the ACR.

### 🗂️ Resource Group Creation

A dedicated resource group named `my-private-aks-rg` was created in the `eastus` region to contain all the related infrastructure components required for this deployment. This resource group acts as a logical container for managing Azure resources such as the AKS cluster, networking components, and the container registry. Grouping related resources together simplifies management, access control, and cleanup.


## 🚀 CI/CD Pipeline Overview

The pipeline (`Deploy to AKS`) is triggered on each push to the `main` branch or manually via GitHub UI. It includes the following steps:

### ✅ Steps Explained

1. **Checkout Code**  
   Clones the repository to the GitHub Actions runner.

2. **Semantic Version Calculation**
   Fetches the latest Git tags, increments the patch version (0.0.X), and creates a new Git tag. This version is then used for the build artifacts.

3. **Node.js Setup & Install**  
   Installs Node.js v22 and project dependencies via `npm install`.

4. **Security Checks**  
   - `npm audit fix`: Automatically fixes known vulnerabilities.
   - `npm audit --audit-level=high`: Detects remaining high/critical issues.
   - `npm run lint`: Ensures code quality and coding standards.

5. **Build the App**  
   Executes the Next.js build process (`npm run build`).

6. **Static Code Analysis**  
   - **CodeQL Analysis**: Detects security vulnerabilities in TypeScript code using GitHub’s built-in scanner.

7. **Build & Push Docker Image to ACR**  
   - Uses `buildx` to build and tag the Docker image with `latest` and the version tag.
   - Pushes image to ACR.

8. **Inject Version into Helm**  
   Updates the `Chart.yaml` and `values.yaml` with the correct version and image tag.

9. **Package & Push Helm Chart to ACR**  
   - Packages Helm chart.
   - Logs in to ACR.
   - Pushes the chart to the OCI registry in ACR.

10. **Helm Deployment to AKS**  
   - Uses Helm to deploy the application to AKS using the updated chart.
   - Waits for pod readiness and validates deployment.

---

## 🌐 Exposing the Application via Ingress

The application is exposed through an **NGINX Ingress Controller**, deployed using Helm. It provisions a public IP to access the app externally.

You can access the app at:

```
https://nextjsbasicapp.<PUBLIC-IP>.nip.io/
```

> Example: `https://nextjsbasicapp.128.203.114.45.nip.io`  
> Uses [`nip.io`](https://nip.io) for instant DNS — no manual configuration needed.

### 🧩 Ingress Rule

The Ingress rule includes:

```yaml
- path: /
  pathType: Prefix
```

This ensures **all traffic under `/`** (e.g., `/`, `/blog`, `/api`) is routed to the backend service — ideal for web apps with client-side routing.

### 🔐 TLS Support

TLS is enabled with a **self-signed certificate** for encrypted HTTPS access in dev/test environments.

### 📄 Helm-Templated Ingress

The Ingress resource is dynamically generated via a Helm template located at:

```
templates/ingress.yaml
```

This allows flexible customization of hostnames, TLS, annotations, and routing paths per environment.

---

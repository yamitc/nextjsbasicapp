# Next.js AKS Deployment with DevSecOps Pipeline

This project demonstrates how to securely build, package, scan, and deploy a **Next.js** application to **Azure Kubernetes Service (AKS)** using a GitHub Actions pipeline. The deployment includes integration with **Azure Container Registry (ACR)**, **Helm charts**, **ingress controller**, and **security best practices**.

---

## 🚀 CI/CD Pipeline Overview

Our pipeline (`Deploy to AKS`) is triggered on each push to the `main` branch or manually via GitHub UI. It includes the following steps:

### ✅ Steps Explained

1. **Checkout Code**  
   Clones the repository to the GitHub Actions runner.

2. **Tag Management**  
   Fetches latest tags, increments patch version (`0.0.X`), and creates a new Git tag. This version is later injected into the Helm chart and Docker image.

3. **Node.js Setup & Install**  
   Installs Node.js v22 and project dependencies via `npm install`.

4. **Security Checks**  
   - `npm audit fix`: Automatically fixes known vulnerabilities.
   - `npm audit --audit-level=high`: Detects remaining high/critical issues.
   - `npm run lint`: Ensures code quality and coding standards.

5. **Build the App**  
   Executes the Next.js build process (`npm run build`).

6. **Static Code Analysis**  
   - **CodeQL Analysis**: Detects security flaws in JavaScript code with GitHub's built-in scanner.

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

## ⚠️ Known Security Vulnerabilities in Next.js

As part of our DevSecOps pipeline, we monitored known vulnerabilities affecting the Next.js framework. Below is a summary of notable issues identified in recent advisories:

### 1. **Server-Side Request Forgery (SSRF) in Server Actions**
- **Advisory:** [GHSA-fr5h-rqp8-mj6g](https://github.com/advisories/GHSA-fr5h-rqp8-mj6g)
- **Impact:** May expose internal services or sensitive data.
- **Resolution:** Upgrade Next.js to a patched version.

### 2. **Cache Poisoning Vulnerability**
- **Advisory:** [GHSA-gp8f-8m3g-qvj9](https://github.com/advisories/GHSA-gp8f-8m3g-qvj9)
- **Impact:** Could show incorrect data or outdated pages.
- **Resolution:** Upgrade Next.js and review cache headers.

### 3. **Denial of Service in Image Optimization**
- **Advisory:** [GHSA-g77x-44xx-532m](https://github.com/advisories/GHSA-g77x-44xx-532m)
- **Impact:** Application crash from malformed images.
- **Resolution:** Update Next.js and sanitize image inputs.

### 4. **Authorization Bypass in Middleware**
- **Advisory:** [GHSA-f82v-jwr5-mffw](https://github.com/advisories/GHSA-f82v-jwr5-mffw)
- **Impact:** Allows unauthorized access to protected routes.
- **Resolution:** Upgrade and harden middleware logic.

### 5. **Next.js Authorization Bypass**
- **Advisory:** [GHSA-7gfc-8cq8-jh5f](https://github.com/advisories/GHSA-7gfc-8cq8-jh5f)
- **Impact:** Bypass access control logic.
- **Resolution:** Use latest patched release.

### 6. **DoS with Server Actions**
- **Advisory:** [GHSA-7m27-7ghc-44w9](https://github.com/advisories/GHSA-7m27-7ghc-44w9)
- **Impact:** Resource exhaustion or application hang.
- **Resolution:** Apply guards against recursive logic.

---

## ✅ Mitigation and Monitoring

- ✅ Dependencies scanned automatically via `npm audit`.
- ✅ Static analysis performed by GitHub CodeQL.
- ✅ Helm and Docker images tagged and validated.
- ✅ All vulnerabilities tracked and addressed proactively.

---

For questions or improvements, feel free to open a pull request or contact the maintainer.


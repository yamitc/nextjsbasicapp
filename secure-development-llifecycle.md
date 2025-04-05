# Secure Development Lifecycle – Contoso

This diagram and explanation describe a secure development lifecycle customized for Contoso, using the current toolchain: Bitbucket, Jenkins, JFrog Artifactory, ArgoCD, SonarQube, Black Duck, Twistlock, Jest, and Playwright.

---

## 🔁 Secure Development Lifecycle Diagram

![Secure Development Lifecycle](./secure-dev-lifecycle.png)

> (Save the image as `secure-dev-lifecycle.png` in the same folder as this Markdown file for proper PDF export.)

---

## 🔐 Lifecycle Explanation (Step-by-Step)

### 1. Developer Workstation
- Developers write code locally using secure tools and workflows.
- Workstation access to internal resources is controlled via **VPN** and **corporate proxy** — ensuring secure connectivity to both company systems and the internet.
- Use tools like **Trunk Code Quality** to run linters, formatters, and security checks automatically before code is committed.
- Optional pre-commit hooks such as **GitLeaks** help prevent accidental exposure of secrets.

---

### 2. Git-based Source Code Platform (e.g., Bitbucket, GitHub, GitLab)
- Developers push their changes to a central Git repository and open a **Pull Request (PR)** for review.
- PRs must meet strict quality gates before they can be merged:
  - ✅ At least one team member must approve the changes
  - ✅ The automated build and tests must pass (triggered by the CI system)
- Webhooks notify the CI/CD system (e.g., Jenkins) to start a pipeline on push or PR merge.
- Important branches like `dev` and `release` are **protected**:
  - ✅ Pull requests are required to make changes
  - ✅ Direct commits are blocked
  - 🚫 Force-push (rewrite history) and branch deletion are blocked

---

### 3. Continuous Integration & Build Platform (e.g., Jenkins, GitHub Actions, GitLab CI)

- The CI pipeline runs automatically on **any branch push** using Git webhooks — including feature branches, bugfixes, and protected branches.
- All pushed code goes through testing, analysis, and security scanning regardless of the branch.
- Only changes merged into protected branches (e.g., `main`, `release`) trigger **promotion workflows** to deploy into test and production environments.
- The pipeline includes multiple stages to ensure **versioned, secure, and tested artifacts** are always produced and promoted safely.

#### 🧭 Early Stage: Versioning
- ✅ **Semantic Version Calculation**:
  - The pipeline starts by calculating the next semantic version (e.g., `1.4.7 → 1.4.8`) based on commit history, branch name, or Git tags.
  - This version is consistently applied to all build artifacts, e.g.:
    - Docker images
    - Helm charts
    - Swagger files

#### 🏗️ Build Stage
- ✅ **Prepare Code and Artifacts for Production**:
  - Compile or transpile code if needed (e.g., TypeScript, Java, SCSS, etc.)
  - Inject environment-specific configurations (e.g., `.env.production`, Helm values, or ConfigMaps)
  - Bundle, optimize, or minify frontend and backend assets (e.g., using Webpack, Vite, esbuild, or other tools)
  - Validate that build outputs (e.g., JS bundles, server packages, compiled binaries) are complete and ready for testing and packaging
  - Store build outputs in the workspace or artifact directory for the next pipeline stages

#### 📦 Helm Chart Packaging
- ✅ **Helm Chart Creation**:
  - Helm charts are rendered using environment-specific values
  - Charts are versioned using the calculated semantic version
  - Linting is applied to validate Helm templates
  - Charts are optionally tested using tools like **helm unittest** or **chart-testing**
  - Packaged `.tgz` files are stored for deployment

---

#### 🐳 Docker Image Build & Push
- ✅ **Container Image Creation**:
  - Docker images are built using production-ready base images
  - Multi-architecture support (e.g., `linux/amd64`, `linux/arm64`) is enabled
  - Image tags include the calculated semantic version
  - Image is scanned for vulnerabilities (Twistlock)
  - Clean images are pushed to **JFrog Artifactory** (or Docker Hub, ECR, etc.)

### 4. Twistlock – Image Security Scan
- The Docker image is scanned for known vulnerabilities.
- Only clean images proceed to deployment.


#### 🧪 Quality & Security Checks
- ✅ **Unit Tests**:
  - Run using **Jest** to test individual functions
- ✅ **Component Tests**:
  - Check interaction between components (e.g., API + DB, UI + Service) using tools like **SuperTest** or **Playwright**
- ✅ **End-to-End (E2E) Tests**:
  - Validate real-world flows with **Playwright**
- ✅ **Static Code Analysis**:
  - Performed by **SonarQube**
- ✅ **Dependency Scanning**:
  - Handled by **Black Duck** to identify vulnerable libraries


#### 🧪 Deployment Testing
- ✅ **Deployment Test / Smoke Test**:
  - Deployed into a test namespace/environment to validate deployment success, readiness, and connectivity

#### 📦 Artifact Management & Promotion
- ✅ **Artifact Storage**:
  - Artifacts are pushed to **JFrog Artifactory**, versioned and signed
- ✅ **Promotion Logic**:
  - Artifacts are promoted from **dev → test → prod** environments
  - Only artifacts that pass **all tests, scans, and deployment validation** move forward

## 🔄 Continuous Delivery with GitOps (e.g., ArgoCD)

This pipeline follows a **Continuous Delivery (CD)** model, where every change that passes all CI stages is automatically prepared for deployment.

- ✅ After successful builds, tests, and security scans:
  - Artifacts (e.g., Docker images, Helm charts) are versioned and published to an artifact repository
  - Deployment files (e.g., Helm values or Kubernetes manifests) are updated in Git

- ✅ **GitOps tooling** (e.g., ArgoCD) automatically detects changes in the Git repository and syncs them to target environments:
  - Deployment to staging or test environments is fully automated
  - Deployment to production environments is gated by manual approval or change control workflows

- ✅ Rollbacks can be safely performed by reverting the last Git commit — restoring the previous application state without manual configuration

This approach ensures that all deployments are:
- **Repeatable** (everything is in Git)
- **Auditable** (Git history + CI logs)
- **Safe** (manual approval before production)
- **Fast** (fully automated up to the prod gate)


## 🔍 Monitoring & Incident Response

- ✅ **Runtime Monitoring**:
  - Use tools like **Azure Monitor**, **Prometheus**, or **Fluent Bit** to collect application and infrastructure telemetry.
- ✅ **Alerting & Notifications**:
  - Alerts for deployment failures, security scan issues, or abnormal traffic patterns are sent to channels like Slack or Teams.
- ✅ **Security Incident Detection**:
  - Runtime threats or policy violations (e.g., from Twistlock) trigger automatic alerts for investigation.
- ✅ **Audit & Traceability**:
  - All actions in the CI/CD process (commits, builds, deployments) are logged with traceable metadata for compliance and rollback.

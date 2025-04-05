# Azure Cloud Migration Plan – Contoso Case Study

## Table of Contents
1. [Introduction](#introduction)
2. [Discovery Phase (Inventory & Assessment)](#discovery-phase-inventory--assessment)
3. [Migration Strategy by Component](#migration-strategy-by-component)
   - [SQL Database (AWS RDS)](#sql-database-aws-rds)
   - [Kubernetes Clusters](#kubernetes-clusters)
   - [Logging (ElasticSearch)](#logging-elasticsearch)
   - [Firewalls (PaloAlto)](#firewalls-paloalto)
   - [ML Tools (Spark & Hadoop)](#ml-tools-spark--hadoop)
4. [Architecture Recommendations](#architecture-recommendations)
5. [Security Considerations](#security-considerations)
6. [Cost Optimization Techniques](#cost-optimization-techniques)
7. [Migration Phases & Timeline](#migration-phases--timeline)
8. [Conclusion](#conclusion)

## Introduction

This migration plan is designed for Contoso Ltd., an organization operating workloads across both AWS and on-premises environments. The company is planning a strategic move to Microsoft Azure to unify its infrastructure, reduce operational costs, improve scalability, and enhance overall security and performance.

This migration is not only a lift-and-shift process but also an opportunity to modernize the technology stack, adopt cloud-native services, and simplify infrastructure management.

The main objectives of this plan are to:

- Conduct a structured discovery and assessment phase.
- Define migration strategies for each system component.
- Align with the customer's goals of cost optimization, low latency, high availability, scalability, and strong security.
- Leverage Azure-native services where possible.
- Ensure minimal downtime and disruption during the transition.

The customer is open to adopting new cloud technologies, which provides flexibility and allows for modernization as part of the migration effort.

## Discovery Phase (Inventory & Assessment)

Before designing the migration, it is critical to understand Contoso’s current infrastructure. This discovery phase gathers information about workloads, databases, networking, security, and operational practices. It ensures that migration steps are aligned with technical needs, business goals, and compliance requirements.

### 1. General Information

- Identify business and technical stakeholders.
- Understand the primary goals of the migration (e.g., cost reduction, modernization, improved security).
- Define timelines, milestones, and any business constraints (e.g., blackout periods, compliance deadlines).

### 2. Applications & Workloads

- Inventory of all business applications and internal tools.
- For each app, record:
  - Hosting location (AWS, On-Prem)
  - Dependencies (e.g., database, storage)
  - Uptime requirements and business criticality
- Identify opportunities to consolidate or modernize applications during migration.

### 3. Databases

- Identify database engines in use (e.g., SQL Server on AWS RDS).
- Note database size, backup configurations, and disaster recovery needs.
- Assess latency and availability requirements.
- Evaluate whether existing solutions can be mapped to Azure PaaS offerings.

### 4. Machine Learning & Big Data

- Identify Spark and Hadoop workloads running on-prem.
- Estimate data volume, processing schedules, and frequency of ML tasks.
- Understand data scientist workflows and dependencies.
- Evaluate readiness for Azure Databricks, Synapse, or Azure ML.

### 5. Security & Network

- Document current firewall configurations (PaloAlto in AWS and On-Prem).
- Review VPNs, VPC/VNet structures, and segmentation strategies.
- Understand compliance needs related to data locality and access control.
- Collect existing IP address ranges and network topology.

### 6. Logging & Monitoring

- Current ElasticSearch setup for log aggregation and search.
- Identify data sources feeding into ElasticSearch.
- Understand log retention policies, alerting mechanisms, and compliance rules.
- Evaluate options for Azure-native or managed ElasticSearch services.

## Migration Strategy by Component

This section outlines specific recommendations for migrating each part of Contoso's current infrastructure to Azure. The goal is to improve scalability, reduce operational overhead, optimize costs, and ensure high levels of performance and security.

### SQL Database (AWS RDS)

**Current State**: SQL database hosted in AWS RDS.

**Recommended Azure Services**:  
- Azure SQL Managed Instance (for SQL Server workloads)  
- Azure Database for PostgreSQL (if migrating to open-source)

**Migration Approach**:
- **Use Azure Database Migration Service (DMS)** to move the database with minimal downtime. This service allows continuous data replication during migration, reducing the impact on live applications.
- **Perform compatibility checks** to ensure stored procedures, triggers, and indexes will work correctly after migration. This avoids issues caused by engine differences between AWS and Azure.
- **Choose the right performance and storage tier** in Azure based on current usage and expected growth. This ensures the database stays responsive and cost-effective.
- **Configure backups, high availability, and geo-replication** to meet business continuity and disaster recovery requirements. These settings help prevent data loss and reduce downtime during failures.

**Benefits**:
- **Fully managed PaaS databases reduce operational overhead** by eliminating the need to manage servers, operating systems, and manual updates.
- **Built-in high availability and security features** such as automatic failover, encryption, and firewall rules improve resilience and protection.
- **Native integration with Azure networking, monitoring, and identity (Azure Active Directory)** allows secure and centralized access control, performance tracking, and role management across services.

### Kubernetes Clusters

**Current State**: Two Kubernetes clusters – one in AWS (EKS), one on-premises.

**Recommended Azure Services**:  
- Azure Kubernetes Service (AKS)  
- Azure Container Registry (ACR)

**Migration Approach**:
- Push container images to ACR to serve as the central registry for workloads.
- Recreate or adapt Kubernetes manifests and Helm charts to ensure compatibility with AKS (e.g., storage classes, ingress controllers).
- Migrate workloads incrementally, testing each application in a staging environment before full cutover.
- Use an **Ingress Controller** to manage incoming traffic to apps inside AKS. Contoso can choose between:
  - **NGINX Ingress Controller**: runs inside the cluster and offers full flexibility and control.
  - **Azure Application Gateway Ingress Controller (AGIC)**: a fully managed alternative that includes SSL, WAF, and path-based routing out of the box.
- Integrate AKS with Azure Monitor and Container Insights for observability and diagnostics.

**Benefits**:
- Fully managed Kubernetes with automatic upgrades, patching, and scaling.
- Deep integration with Azure networking, identity (Azure AD), and CI/CD tools.
- Simplified operations compared to managing on-prem or self-hosted clusters.

### Logging (ElasticSearch)

**Current State**: ElasticSearch hosted on-premises for log aggregation and analysis.

**Recommended Azure Services**:  
- Azure Monitor and Log Analytics  
- Or Elastic Cloud (managed ElasticSearch in Azure Marketplace)

**Migration Approach**:
- Route logs from applications, Kubernetes clusters, and infrastructure to Azure Monitor using Fluent Bit or Azure Monitor Agent.
- If existing Kibana dashboards and ElasticSearch features are heavily used, migrate to Elastic Cloud and reconfigure dashboards and queries accordingly.
- Define log retention, alerting rules, and compliance policies to align with operational and legal requirements.

**Benefits**:
- Fully managed and scalable log analysis platform with no need to manage ElasticSearch infrastructure.
- Deep integration with Azure services such as Security Center, Application Insights, and alerting systems.
- Reduced operational burden by eliminating on-prem maintenance and hardware dependencies.

### Firewalls (PaloAlto)

**Current State**: Contoso is currently using PaloAlto firewalls in both AWS and on-premises to control traffic, protect sensitive systems, and manage VPN connections.

**Migration Approach**:
- If Contoso prefers to continue using PaloAlto, we can deploy the same firewall software in Azure, called **PaloAlto VM-Series**. This version runs as a virtual machine in Azure and supports the same rules, policies, and tools the security team already knows.
- Alternatively, Azure offers its own **built-in firewall tools** that are easier to manage, cost less, and fully integrate with other Azure services. These include:
  - **Azure Firewall** – a central, cloud-managed firewall to control traffic across the entire network.
  - **Network Security Groups (NSGs)** – lightweight firewalls that control access to specific VMs or subnets.
  - **Web Application Firewall (WAF)** – protects web apps from common attacks like SQL injection and cross-site scripting.
- We will design the Azure network using **subnets** — dividing it into secure zones:
  - **Public subnet**: for web apps and APIs accessible from the internet.
  - **Private subnet**: for internal services like databases or admin tools.
- Firewall rules will be applied to:
  - Control which services can talk to each other.
  - Block unauthorized access from the outside world.
  - Allow secure remote access using **Azure Bastion** or **Just-in-Time (JIT)** access to avoid exposing public IPs.

**Benefits**:
- **Familiarity and continuity** if using PaloAlto VM-Series — same tools, same policies.
- **Simplified security management** and lower costs if using Azure-native firewalls.
- A clearly segmented, well-protected network structure that meets security best practices.

### ML Tools – Spark & Hadoop

**Current State**: Contoso is using Apache Spark and Hadoop on their own servers to process large datasets and run machine learning (ML) jobs. These systems are powerful, but complex to manage and scale.

**Migration Approach**:
- Move big data from existing Hadoop storage (HDFS) to **Azure Data Lake Storage Gen2**, a secure and scalable cloud-based data storage system.
- Run existing Spark jobs using **Azure Databricks**, a managed Spark service that’s faster, easier to use, and scales automatically.
- If Contoso uses Spark for machine learning, we recommend using **Azure Machine Learning** to track experiments and deploy models.
- Enable autoscaling so resources are only used (and paid for) during actual processing, reducing overall cost.

**Benefits**:
- No need to maintain on-prem servers or clusters.
- Faster and easier data processing using familiar Spark APIs.
- Supports advanced analytics and ML workflows.
- Everything works together inside Azure — with secure storage, monitoring, and automation built in.

## Architecture Recommendations

We recommend designing Contoso’s new Azure environment around the following core principles: simplicity, scalability, security, and cost-efficiency.

### 🔷 Key Building Blocks

- **Azure Kubernetes Service (AKS)** – for containerized applications and workloads, replacing EKS and on-prem Kubernetes.
- **Azure Container Registry (ACR)** – for storing Docker images and Helm charts used in AKS.
- **Azure SQL Managed Instance / PostgreSQL** – for migrating SQL databases from AWS RDS.
- **Azure Monitor + Log Analytics** – for collecting, analyzing, and alerting on logs and metrics.
- **Azure Firewall, NSGs, and WAF** – for network and application-level security.
- **Azure Databricks + Data Lake Storage Gen2** – for processing large datasets and running ML jobs.
- **Azure Machine Learning** – for model training and deployment (if needed).

### 🔷 Network and Security Design

- All services will be deployed inside a secure **Azure Virtual Network** (VNet), divided into:
  - **Public subnets** for services that need internet access (e.g., web apps).
  - **Private subnets** for internal services like databases and processing nodes.
- Traffic will be controlled using:
  - **Azure Firewall** (network-wide protection)
  - **NSGs** (granular access rules at VM/subnet level)
  - **WAF** (protects web applications from common threats)
- Remote access will be provided via **Azure Bastion** or **Just-in-Time VM Access**, with no exposed public IPs.

### 🔷 Scalability and Performance

- Services like AKS, Databricks, and SQL will use **autoscaling** to match workload demand.
- Azure Load Balancers and Application Gateways will be used to distribute traffic and ensure high availability.
- Data and applications will be spread across **availability zones** for better uptime and fault tolerance.

This architecture ensures that Contoso's new environment is cloud-native, secure, and ready to scale as the business grows.

## Security Considerations

When moving to the cloud, keeping everything safe is one of the most important goals. This plan makes sure Contoso’s data, applications, and systems are protected — without making things complicated for users or the IT team.

### 🔐 Who Can Access What (Identity and Access Control)
- Azure Active Directory (Azure AD) will be used to manage who can log in and what they can do.
- Each person or system will get only the access they need — no more, no less.
- Important accounts (like admins) will have extra protection using two-step verification (multi-factor authentication).

### 🌐 Keeping the Network Safe
- All systems will be placed inside a secure "private network" in Azure.
- Public-facing systems (like websites) will be separated from private systems (like databases).
- Azure Firewall will protect the entire network, while smaller filters (Network Security Groups) control access between parts of it.
- Web applications will be protected using a special Web Application Firewall (WAF) to block common attacks like fake login attempts or suspicious requests.
- There will be no open doors: instead of public IP addresses, we’ll use Azure Bastion or time-limited access tools to let admins connect only when needed — and only for a short time.

### 🔒 Protecting Data
- All information will be encrypted — both when stored and when sent over the internet.
- Sensitive things like passwords or certificates will be stored in a secure place called Azure Key Vault.
- Backups will be safe and stored in secure Azure data centers that follow global security standards.

### 📈 Watching for Problems
- Azure will continuously check for issues, misconfigurations, or unusual activity.
- Security tools will alert the team if something looks suspicious.
- All activity logs will be collected and stored, so if anything goes wrong, the team can quickly investigate and respond.

By combining these security tools and best practices, Contoso’s new Azure environment will be secure, well-organized, and ready for future growth.

## Cost Optimization Techniques

Moving to Azure doesn’t just make systems more modern — it also helps Contoso reduce costs by paying only for what’s really needed. Here are some of the key ways we’ll help control and optimize cloud spending:

### ⏱️ Pay Only When You Use
- Azure services like **web apps**, **databases**, and **data processing jobs** can automatically **scale up** when more users are active, and **scale down** during slower periods — so Contoso only pays for what is actually used.
- For background or non-urgent jobs — like nightly reports or weekly data processing — we can use **spot instances**, which offer deep discounts in exchange for flexibility. These are ideal when it’s okay for a task to restart if interrupted.
- For systems we know will run constantly (like databases), we can save a lot by using **reserved capacity**, which locks in lower prices when committing to 1 or 3 years of usage.

### 📊 Monitor Usage and Costs
- We'll use **Azure Cost Management** to track how much each service is spending, find unused resources, and set alerts or budgets.
- Dashboards and reports will make it easy to see where money is going — and stop waste before it adds up.

### 💡 Use the Right Services for the Job
- Where possible, we’ll use **Platform-as-a-Service (PaaS)** instead of running full servers — like **Azure SQL Database** instead of managing a virtual machine.
- This means less maintenance, more automation, and usually lower cost.

### 🧠 Plan for Future Growth
- We can use **reserved instances** or **commitment pricing** for services we know we’ll use long term (like databases or VMs), saving up to 70% over pay-as-you-go pricing.
- This allows Contoso to lock in better prices while planning for steady growth.

### 🔁 Review Regularly
- Part of the ongoing plan is to **review cloud usage regularly**, clean up what’s no longer needed, and adjust resources as usage changes over time.

By using these strategies, Contoso can enjoy all the benefits of Azure — without unexpected bills or overprovisioned systems.

## Conclusion

This migration plan offers Contoso a clear and flexible path to move their systems from AWS and on-premises to Azure in a safe, scalable, and cost-effective way.

By using Azure’s managed services, Contoso will:

- Reduce the time and effort needed to maintain infrastructure
- Improve performance and reliability across all systems
- Strengthen security using built-in cloud protections
- Gain more visibility and control over costs
- Be ready for future growth and innovation

Each part of the environment — from applications to machine learning — has a recommended approach and matching Azure service that fits Contoso’s needs and goals.

The result is a modern, cloud-native setup that simplifies operations, improves security, and helps Contoso deliver more value to its users and business.



# Self-Service Vertex AI Workbench Platform

A fully automated, GitOps-driven platform that allows developers to securely provision and manage Vertex AI Workbench instances on Google Cloud Platform (GCP) using GitHub Actions and Terraform.

This project eliminates manual infrastructure provisioning, standardizes data science environments, and enforces strict IAM access controls and FinOps guardrails (e.g., auto-shutdown policies).

## Table of Contents
- [Architecture & Design](#-architecture--design)
- [Prerequisites](#-prerequisites)
- [Setup Instructions](#-setup-instructions)
- [Usage (Self-Service Workflows)](#-usage-self-service-workflows)
- [Security & IAM](#-security--iam)

## Architecture & Design
This platform is designed to provide a secure, on-demand infrastructure pipeline while completely abstracting the underlying complexity from the end-user. 

**The End-to-End Flow:**
1. **Request Interface:** Developers use GitHub Actions (`workflow_dispatch`) as a self-service portal to request a notebook, selecting their required region, compute size, and optional GPUs. 
2. **Approval Gating:** The GitHub Action dynamically assesses the request. Standard CPU notebooks are auto-approved, while any request for expensive GPU accelerators is automatically routed to a designated `gpu-approval` environment requiring administrator sign-off.
3. **Zero-Trust Authentication:** The pipeline authenticates to Google Cloud using Workload Identity Federation. This eliminates the need to store long-lived, highly privileged JSON service account keys in GitHub.
4. **State & Workspace Isolation:** Terraform initializes using a remote Google Cloud Storage (GCS) backend. To prevent state conflicts between multiple developers provisioning notebooks simultaneously, the pipeline dynamically scopes the state prefix using the developer's GitHub username (`state/users/<github-actor>`) and creates a dedicated Terraform workspace for that specific instance.
5. **Secure Provisioning:** Terraform provisions the infrastructure:
    * A strictly scoped, least-privilege runtime Service Account dedicated solely to that notebook.
    * A User-Managed Vertex AI Workbench instance deployed in a private subnet with no public IP.
    * Cloud Monitoring alert policies configured to notify administrators of any unauthorized Identity-Aware Proxy (IAP) access attempts.
6. **FinOps Guardrails:** The module automatically injects mandatory cost-allocation labels (`owner`, `cost_center`) and hardcodes an aggressive idle-timeout policy (e.g., auto-shutdown after 2 hours of inactivity) that developers cannot bypass.
7. **Delivery:** Upon successful deployment, the pipeline extracts the secure JupyterLab Proxy URI from the Terraform state and outputs it directly into the GitHub Actions run summary for one-click access via IAP.

## Prerequisites
Before deploying this platform, ensure the following are set up in your GCP environment:

1.  **Google Cloud APIs Enabled:**
    * Compute Engine API (`compute.googleapis.com`)
    * Vertex AI API (`aiplatform.googleapis.com`)
    * Cloud Monitoring API (`monitoring.googleapis.com`)
    * IAM Service Account Credentials API (`iamcredentials.googleapis.com`)
2.  **Remote State Backend:** A GCS bucket must exist in your project to store Terraform state files.
3.  **VPC Network:** An existing VPC network with a private subnetwork configured in your target regions.

## Setup Instructions

Follow these steps to deploy and configure the CI/CD pipeline.

### Step 1: Configure Workload Identity Federation (WIF)
To allow GitHub Actions to authenticate to GCP securely:
1. Create a Workload Identity Pool in GCP.
2. Create an OIDC Provider attached to GitHub Actions.
3. Bind your GitHub repository subject to your pipeline's service account, granting it the `roles/iam.workloadIdentityUser` role.

### Step 2: Configure Pipeline Permissions
Ensure your pipeline service account (the one executing the Terraform code) has the following IAM roles:
* `roles/notebooks.admin`
* `roles/iam.serviceAccountAdmin`
* `roles/iam.securityAdmin`
* `roles/compute.networkUser`
* `roles/monitoring.editor`

### Step 3: Configure GitHub Actions Secrets, Variables, and Environments
Navigate to your GitHub Repository **Settings > Secrets and variables > Actions** to configure the pipeline dependencies. By setting these, your workflow files remain clean and completely free of hardcoded project details.

**1. Repository Variables**
Go to the **Variables** tab and add the following:
* `GCP_PROJECT_ID`: Your Google Cloud Project ID.
* `GCP_STATE_BUCKET`: The name of the GCS bucket used for the Terraform backend.
* `WORKLOAD_IDENTITY_PROVIDER`: The full resource path to your WIF provider (e.g., `projects/123456789/locations/global/workloadIdentityPools/pool-name/providers/provider-name`).
* `SERVICE_ACCOUNT`: The email address of the service account used to authenticate GitHub Actions to GCP.
* `GCP_VPC_NETWORK_ID`: The full resource path to your VPC Network (e.g., `projects/<PROJECT_ID>/global/networks/<VPC_NAME>`).

**2. Repository Secrets**
Go to the **Secrets** tab and add the following secure values:
* `ADMIN_EMAIL`: The email address that will receive Cloud Monitoring security alerts for unauthorized access attempts.
* `GCP_TERRAFORM_RUNNER_IDENTITY`: The formatted IAM identity running Terraform (e.g., `serviceAccount:your-terraform-sa@your-project.iam.gserviceaccount.com`). This is required to set up the ActAs bindings.
* `SA_ACCOUNT_TERRAFORM`: The dedicated service account identity or credentials used strictly for the Terraform execution layer.

**3. Repository Environments (Critical for GPU Gating)**
Go to **Settings > Environments** and create the following:
* `gpu-approval`: After creating this environment, check the **Required reviewers** box and add your platform administrators. The workflow is programmed to pause and wait for approval from these users if a developer requests an accelerator type other than `NONE`.
* `auto-approve`: Create this environment but leave all protection rules blank. Standard CPU requests route here to provision immediately.

## Usage (Self-Service Workflows)

Developers do not need to touch Terraform code or GCP directly. All interaction happens via the GitHub Actions **Run workflow** UI.

### Provisioning a Workbench
1. Navigate to the **Actions** tab in this repository.
2. Select the **Provision Vertex AI Workbench** workflow.
3. Click **Run workflow** and fill in the required parameters:
    * **Developer Email:** Your organizational email.
    * **Instance Name:** A unique name for your notebook.
    * **Compute Size / GPUs / Disk:** Select from the pre-approved dropdowns.
4. Once the action completes successfully, expand the `Output Connection Details` step in the logs to click your direct **JupyterLab URL**.

### Tearing Down a Workbench
1. Navigate to the **Actions** tab.
2. Select the **Teardown Vertex AI Workbench** workflow.
3. Click **Run workflow** and input the **Instance Name** of the notebook you wish to destroy. 
4. The pipeline will securely locate your specific Terraform workspace and destroy only your provisioned resources.
# Self-Service Vertex AI Workbench Platform

Welcome to the Self-Service Infrastructure Portal. This GitOps-driven platform allows developers and data scientists to securely provision and manage their own Vertex AI Workbench instances on Google Cloud Platform (GCP) without needing direct cloud access or writing Terraform code.

## Features
* **Zero-Touch Provisioning:** Request your infrastructure directly through GitHub Actions.
* **Cost Management:** Built-in FinOps guardrails, including mandatory tagging and automated idle-shutdown policies.
* **Secure Access:** Notebooks are deployed privately and accessed securely via Identity-Aware Proxy (IAP) with no public IPs.
* **GPU Gating:** Standard CPU notebooks are approved automatically. High-cost GPU requests are automatically routed to administrators for approval.

---

## How to Use This Platform

All provisioning and destruction are handled through the **Actions** tab in this repository.

### 1. Provision a Vertex AI Workbench
This workflow creates a secure, private JupyterLab notebook tailored to your exact specifications. 

1. Navigate to the **Actions** tab.
2. Select **Provision Vertex AI Workbench** from the left menu.
3. Click the **Run workflow** dropdown and provide the following details:
    * **Developer Email:** Your organizational email address.
    * **Instance Name:** A unique identifier for your notebook (e.g., `alpha-ml-notebook`).
    * **GCP Region:** Select your preferred deployment region.
    * **Compute Size:** Select the CPU/RAM footprint.
    * **GPU Type & Count:** Select your accelerator (or `NONE`). 
    * **Boot Disk Size (GB):** Default is `150`.
    * **Auto-Shutdown Inactivity:** Choose `7200` (2 hours) or `14400` (4 hours) of idle time before the machine turns off.
4. Click **Run workflow**.

> 🛑 **Approval Process:** If you select `NONE` for GPUs, your notebook will deploy immediately (takes ~5 mins). If you select a GPU, the workflow will pause and alert an administrator. Once approved, provisioning will resume.

**Accessing Your Notebook:**
Once the workflow has a green checkmark, click into the run and expand the `Output Connection Details` step. You will find a direct **JupyterLab URL** to access your secure environment immediately.

### 2. Teardown a Vertex AI Workbench
When you are finished with your project, you must destroy your infrastructure to stop incurring costs. This safely deletes *only* your specific notebook.

1. Navigate to the **Actions** tab.
2. Select **Teardown Vertex AI Workbench**.
3. Click **Run workflow**.
4. Enter the exact **Instance Name** of the notebook you provided during provisioning.
5. Click **Run workflow**. The system will locate your isolated environment and permanently delete it.

---
*For Platform Administrators looking to deploy this architecture, please refer to the [Administrator Setup Guide](SETUP.md).*
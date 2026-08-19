# Exercise 2: Create VM to migrate web application

### Estimated Duration: 30 Minutes

02-Create VM to migrate web application## 📘 Lab Scenario

In this exercise, you create a new **Windows Server 2022 Datacenter: Azure Edition** virtual machine that will be the destination for migrating Tailspin Toys' web application to Azure. You then connect to it securely using **Azure Bastion**. Windows Server Azure Edition is a special image with capabilities such as Hotpatch (installing updates without rebooting) that are only available on Azure.

## 📋 Overview

This exercise provisions the Azure virtual machine that will host the migrated web application. You create the VM inside the lab virtual network, allow only HTTPS inbound traffic, keep it off the public internet for RDP, and then validate secure administrative access using Azure Bastion.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- **Task 1**: Create a Windows Server 2022 Azure Edition virtual machine
- **Task 2**: Connect to the VM using Azure Bastion

---

## Task 1: Create a Windows Server 2022 Azure Edition virtual machine

1. Sign in to the **Azure Portal** at <https://portal.azure.com> using your lab credentials:

   - **Username**: <inject key="AzureAdUserEmail"></inject>
   - **Password**: <inject key="AzureAdUserPassword"></inject>

2. On the Azure Portal home page, select **Create a resource**.

   ![](Images/Ex2-T1-S2.png)

3. On the **Create a resource** page, select **Virtual machine** under **Popular Azure services** (or search for **Virtual machine** and select **Create**).

   ![](Images/Ex2-T1-S3.png)

4. On the **Create a virtual machine** > **Basics** tab, enter the following under **Project details** and **Instance details**:

   - **Subscription (1)**: The lab subscription
   - **Resource group (2)**: **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Virtual machine name (3)**: **tailspin-webapp-vm**
   - **Region (4)**: **Central US**
   - **Image (5)**: **Windows Server 2022 Datacenter: Azure Edition - x64 Gen2**
   - **Size (6)**: **Standard_D4s_v5** (select **See all sizes** if it isn't listed)

   ![](Images/Ex2-T1-S4.png)

5. Under **Administrator account**, enter:

   - **Username (1)**: demouser
   - **Password (2)**: demo!pass123
   - **Confirm password (3)**: demo!pass123

   ![](Images/Ex2-T1-S5.png)

6. Under **Inbound port rules**, set the following:

   - **Public inbound ports (1)**: Allow selected ports
   - **Select inbound ports (2)**: HTTPS (443)

   ![](Images/Ex2-T1-S6.png)

7. Select **Next: Disks >**, then **Next: Networking >** to reach the **Networking** tab. Enter the following so the VM joins the lab virtual network with no public IP:

   - **Virtual network (1)**: **vnet-sqlmi--cus**
   - **Subnet (2)**: **Management**
   - **Public IP (3)**: None

   > **Note:** Setting the Public IP to **None** keeps the VM off the public internet. You will connect to it securely using Azure Bastion in the next task.

   ![](Images/Ex2-T1-S7.png)

8. Select **Review + create**.

   ![](Images/Ex2-T1-S8.png)

9. After the **Validation passed** message appears, select **Create** to begin provisioning the virtual machine.

   ![](Images/Ex2-T1-S9.png)

10. Wait for the deployment to complete, then select **Go to resource**.

    ![](Images/Ex2-T1-S10.png)

---

## Task 2: Connect to the VM using Azure Bastion

1. On the **tailspin-webapp-vm** virtual machine page, select **Connect (1)** at the top, then select **Connect via Bastion (2)** (or select **Bastion** from the left menu under **Operations**).

   ![](Images/Ex2-T2-S1.png)

2. On the **Bastion** pane, enter the following credentials, then select **Connect**:

   - **Username**: demouser
   - **Password**: demo!pass123

   > **Note:** The Azure Bastion host (named similar to **tailspin-hub-bastion**) was created as part of the lab environment, so you can connect without deploying anything extra.

   ![](Images/Ex2-T2-S2.png)

3. A new browser tab opens with the VM connected over RDP through Azure Bastion. This confirms secure remote access works.

   ![](Images/Ex2-T2-S3.png)

4. To end the session, simply close the browser tab.

> **Note:** Now that the Windows Server 2022 VM exists in Azure, Tailspin Toys can update their CI/CD pipelines in Azure DevOps to deploy the web application code to this virtual machine as they prepare to migrate the application to Azure.

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="00000000-0000-0000-0000-000000000002" />

## 🧾 Summary

In this exercise, you accomplished the following:

- Created a Windows Server 2022 Datacenter: Azure Edition virtual machine to host the migrated web application.
- Placed the VM in the lab virtual network with only HTTPS inbound access and no public IP.
- Verified secure remote desktop access to the VM using Azure Bastion.

## You have successfully completed this exercise. Click **Next >>** to proceed with the next exercise.

![](Images/2nct.png)

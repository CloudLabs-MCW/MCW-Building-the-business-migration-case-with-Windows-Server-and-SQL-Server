# Exercise 2: Create VM to migrate web application

### Estimated Duration: 45 Minutes

## 📘 Lab Scenario

In this exercise, you create a new **Windows Server 2025 Datacenter: Azure Edition** virtual machine that will be the destination for migrating Tailspin Toys' web application to Azure. You then connect to it securely using **Azure Bastion**. Windows Server Datacenter: Azure Edition is a virtual-only edition that runs as an Azure virtual machine and includes capabilities such as Hotpatching, which installs security updates without requiring a restart.

## 📋 Overview

This exercise provisions the Azure virtual machine that will host the migrated web application. You create the virtual machine inside the lab virtual network, keep it off the public internet by omitting a public IP address, and then validate secure administrative access using Azure Bastion.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- **Task 1:** Create a Windows Server 2025 Datacenter: Azure Edition virtual machine
- **Task 2:** Connect to the virtual machine using Azure Bastion

---

## Task 1: Create a Windows Server 2025 Datacenter: Azure Edition virtual machine

1. Sign in to the **Azure portal** at `https://portal.azure.com` using your lab credentials:

   - **Username:** <inject key="AzureAdUserEmail"></inject>
   - **Password:** <inject key="AzureAdUserPassword"></inject>

1. On the Azure portal home page, select **Create a resource**.

   ![](img/Lab02/img1.png)

1. On the **Create a resource** page, select **Virtual machine** under **Popular Azure services**. Alternatively, search for **Virtual machine** and then select **Create**.

   ![](img/Lab02/img2.png)

1. On the **Create a virtual machine** > **Basics** tab, enter the following values under **Project details** and **Instance details**:

   - **Subscription:** The lab subscription
   - **Resource group:** **ODL-tailspin-<inject key="DeploymentID" enableCopy="false"/>-tailspin**
   - **Virtual machine name (1)**: **tailspin-webapp-vm**
   - **Region (2)**: **Central US**
   - **Image (3)**: **Windows Server 2025 Datacenter: Azure Edition - x64 Gen2**
   - **Size (4)**: **Standard_D2s_v3**

   > **Note:** If the size is not listed, select **See all sizes** and search for it.

   ![](img/Lab02/img3.png)

1. Under **Administrator account**, enter the following values, and then select **Next (4)**:

   - **Username (1)**: azureuser
   - **Password (2)**: azureuser!pass123
   - **Confirm password (3)**: azureuser!pass123

   ![](img/Lab02/img4.png)

1. Select **Next: Disks >**, and then select **Next: Networking >** to reach the **Networking** tab. Enter the following values so that the virtual machine joins the lab virtual network with no public IP address, and then select **Review + create (4)**:

   - **Virtual network (1)**: **vnet-sqlmi-hol**
   - **Subnet (2)**: **Managed**
   - **Public IP (3)**: **None**

   > **Note:** Setting the public IP address to **None** keeps the virtual machine off the public internet. You will connect to it securely using Azure Bastion in the next task.

   ![](img/Lab02/img5.png)

1. After the **Validation passed** message appears, select **Create** to begin provisioning the virtual machine.

   ![](img/Lab02/img6.png)

1. Wait for the deployment to complete, and then select **Go to resource**.

   ![](img/Lab02/img7.png)

---

## Task 2: Connect to the virtual machine using Azure Bastion

1. On the **tailspin-webapp-vm** virtual machine page, select **Connect (1)** at the top, and then select **Connect via Bastion (2)**. Alternatively, select **Bastion** from the left menu under **Connect**.

   ![](img/Lab02/img8.png)

1. On the **Bastion** pane, enter the following credentials, and then select **Connect**:

   - **Username:** azureuser
   - **Password:** azureuser!pass123

   > **Note:** The Azure Bastion host, named similar to **tailspin-hub-bastion**, was created as part of the lab environment, so you can connect without deploying anything extra.

   ![](img/Lab02/img10.png)

1. A new browser tab opens with the virtual machine connected over RDP through Azure Bastion. This confirms that secure remote access works.

   ![](img/Lab02/img9.png)

1. To end the session, close the browser tab.

> **Note:** Now that the Windows Server 2025 virtual machine exists in Azure, Tailspin Toys can update its CI/CD pipelines in Azure DevOps to deploy the web application code to this virtual machine in preparation for migrating the application to Azure.

---

## 🧾 Summary

In this exercise, you accomplished the following:

- Created a Windows Server 2025 Datacenter: Azure Edition virtual machine to host the migrated web application.
- Placed the virtual machine in the lab virtual network with no public IP address.
- Verified secure remote desktop access to the virtual machine using Azure Bastion.

### You have successfully completed this exercise. Click on **Next >>** to proceed with the next exercise.

![](Images/2nct.png)
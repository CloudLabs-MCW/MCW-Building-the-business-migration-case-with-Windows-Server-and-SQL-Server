# Building the Business Migration Case with Windows Server and SQL Server

### Overall Estimated Duration: 3 Hours

## 📘 Lab Scenario

Tailspin Toys is planning to migrate their on-premises Windows Server and SQL Server workloads to Azure. As part of this migration strategy, they need to move their on-premises SQL Server database to Azure SQL Managed Instance, stand up a Windows Server virtual machine in Azure to host their migrated web application, and Azure Arc-enable an on-premises server that will remain on-premises so it can be managed centrally alongside their Azure resources.

As a Cloud Engineer at Tailspin Toys, you will migrate the on-premises **WideWorldImporters** SQL Server database to Azure SQL Managed Instance using Azure Database Migration Service (DMS), create a Windows Server 2022 Azure Edition virtual machine as the destination for the web application, and Azure Arc-enable an on-premises Windows Server virtual machine to bring it under unified Azure management.

## 📖 Overview

Migrating existing workloads to the cloud requires careful planning, assessment, and the right set of tools. This lab walks through a realistic migration scenario in which an organization moves a production SQL Server database to a fully managed Azure SQL Managed Instance, provisions Azure infrastructure to host a migrated application, and extends Azure management to servers that will remain on-premises using Azure Arc.

The lab begins by assessing and migrating the on-premises SQL Server database to Azure SQL Managed Instance using the Azure SQL Migration extension. It then moves on to provisioning a Windows Server 2022 Azure Edition virtual machine that will serve as the destination for the migrated web application. Finally, it demonstrates how to Azure Arc-enable an on-premises virtual machine so that it can be governed, monitored, and managed from within Azure alongside native Azure resources.

## 🎯 Objectives

By the end of this lab, you will be able to:

- **Exercise 1 - SQL database migration**: Back up the on-premises WideWorldImporters database and migrate it to a pre-provisioned Azure SQL Managed Instance using Azure Database Migration Service (DMS) from the Azure Portal.

- **Exercise 2 - Create VM to migrate web application**: Create a Windows Server 2022 Datacenter: Azure Edition virtual machine to serve as the destination host for the migrated web application, and validate secure remote access using Azure Bastion.

- **Exercise 3 - Azure Arc-enable on-premises VM**: Generate and run the Azure Arc onboarding script to connect an on-premises Windows Server virtual machine to Azure, enabling unified management through Azure Arc.

## ⚙️ Pre-requisites

Participants should have:

- Basic understanding of Azure services such as Azure SQL Managed Instance and Azure Virtual Machines.
- Basic familiarity with SQL Server database concepts and migration.
- Basic familiarity with the Azure Portal.

## 🏗️ Architecture

This architecture represents a hybrid migration workflow. A simulated on-premises environment consisting of a Hyper-V host virtual machine and a SQL Server virtual machine runs the source WideWorldImporters database. The database is assessed and migrated to a pre-provisioned Azure SQL Managed Instance that resides in a delegated subnet within an Azure virtual network. A Windows Server 2022 Azure Edition virtual machine is provisioned within the same virtual network to host the migrated web application, with secure administrative access provided through Azure Bastion. An on-premises virtual machine running within the Hyper-V host is Azure Arc-enabled so it can be managed centrally from Azure without being migrated.

## 🖼️ Architecture Diagram

![](./Images/Architecture.png)

### 🔍 Explanation of Components

- **Simulated on-premises Hyper-V host VM:** A Windows Server virtual machine in Azure that hosts a nested on-premises virtual machine (OnPremVM), simulating the customer's on-premises environment for the Azure Arc scenario.
- **Simulated on-premises SQL Server VM:** A Windows Server virtual machine running SQL Server that holds the source WideWorldImporters database to be migrated.
- **Azure SQL Managed Instance:** The fully managed PaaS target for the database migration, pre-provisioned in a delegated subnet within the lab virtual network.
- **Azure Database Migration Service (DMS):** The current, supported Azure service used to orchestrate the online migration of the database to Azure SQL Managed Instance from the Azure Portal.
- **SQL Server Management Studio (SSMS):** Used on the source SQL Server VM to create the database backup.
- **Windows Server 2022 Azure Edition VM:** The destination virtual machine that will host the migrated web application, benefiting from Azure Edition capabilities such as Hotpatch.
- **Azure Bastion:** Provides secure RDP connectivity to the Azure virtual machines directly from the Azure Portal without exposing public RDP endpoints.
- **Azure Arc:** Extends Azure management, governance, and monitoring to the on-premises virtual machine through the Azure Connected Machine agent.
- **Azure Virtual Network:** Hosts the lab resources, including a dedicated delegated subnet for the Azure SQL Managed Instance and a management subnet for the virtual machines.

## 🚀 Getting Started with the lab

Welcome to your Building the Business Migration Case with Windows Server and SQL Server workshop. Let's begin by making the most of this experience:

## Accessing Your Lab Environment

Once you're ready to dive in, your virtual machine and **Guide** will be right at your fingertips within your web browser.

![Access Your VM and Lab Guide](./Images/guideee.png)

> **Note:** **If you see a PowerShell window running, please minimize it after accessing the environment to ensure the script continues to run in the background without interruption.**

### Virtual Machine & Lab Guide

Your virtual machine is your workhorse throughout the workshop. The lab guide is your roadmap to success.

## Exploring Your Lab Resources

To get a better understanding of your lab resources and credentials, navigate to the **Environment** tab.

![Explore Lab Resources](./Images/bi1.png)

## Utilizing the Split Window Feature

For convenience, you can open the lab guide in a separate window by selecting the **Split Window** button from the top right corner.

![Use the Split Window Feature](./Images/splittt.png)

## Managing Your Virtual Machine

Feel free to **Start, Stop, or Restart (2)** your virtual machine as needed from the **Resources (1)** tab. Your experience is in your hands!

![Manage Your Virtual Machine](./Images/vmssr2.png)

## Lab Guide Zoom In/Zoom Out

To adjust the zoom level for the environment page, click the **A↕** icon located next to the timer in the lab environment.

![](./Images/zumm.png)

## Let's Get Started with Azure Portal

1. On your virtual machine, click on the Azure Portal icon.

   ![azure portal desktop icon](./Images/portalll.png)

2. On the **Sign in to Microsoft Azure** tab, enter the following **email/username (1)**, and click on **Next (2)**.

   - **Email/Username:** <inject key="AzureAdUserEmail"></inject>

     ![](Images/odlusr.png)

3. Now enter the following **Password (1)** and click on **Sign in (2)**.

   - **Password:** <inject key="AzureAdUserPassword"></inject>

     ![](Images/odltap.png)

4. If prompted to **stay signed in**, you can click **No**.

   ![](Images/staysignn.png)

## 📞 Support Contact

The CloudLabs support team is available 24/7, 365 days a year, via email and live chat to ensure seamless assistance at any time. We offer dedicated support channels tailored specifically for both learners and instructors, ensuring that all your needs are promptly and efficiently addressed.

Learner Support Contacts:

- Email Support: [cloudlabs-support@spektrasystems.com](mailto:cloudlabs-support@spektrasystems.com)
- Live Chat Support: https://cloudlabs.ai/labs-support

Click **Next >>** from the bottom right corner to embark on your Lab journey!

![](Images/1nct.png)

Now you're all set to explore the powerful world of technology. Feel free to reach out if you have any questions along the way. Enjoy your workshop!

## Happy Learning!!

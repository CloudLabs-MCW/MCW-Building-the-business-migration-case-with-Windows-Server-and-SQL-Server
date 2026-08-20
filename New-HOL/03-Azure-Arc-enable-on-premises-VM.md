# Exercise 3: Azure Arc-enable on-premises VM

### Estimated Duration: 45 Minutes

## 📘 Lab Scenario

In this exercise, you Azure Arc-enable a Windows Server virtual machine that Tailspin Toys runs on-premises. There are no plans to migrate this server to Azure, but Tailspin Toys wants to manage all of their servers — both in Azure and on-premises — from a single place. **Azure Arc** makes this possible by projecting the on-premises server into Azure so it can be governed and managed alongside native Azure resources.

## 📋 Overview

This exercise extends Azure management to a server that stays on-premises. You generate an Azure Arc onboarding script from the Azure Portal, run it on a simulated on-premises virtual machine (running inside a Hyper-V host), and then verify the machine appears in Azure as a **Connected** Azure Arc-enabled server.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- **Task 1**: Generate the Azure Arc onboarding script
- **Task 2**: Run the script on the on-premises VM
- **Task 3**: Verify the Azure Arc-enabled server

---

## Task 1: Generate the Azure Arc onboarding script

1. Sign in to the **Azure Portal** at <https://portal.azure.com>.

2. In the top **Search** bar, type **Azure Arc (1)** and select **Azure Arc (2)**.

   ![](Images/Ex3-T1-S2.png)

3. In the Azure Arc menu on the left, expand **Infrastructure (1)**, then select **Machines (2)**.

   ![](Images/Ex3-T1-S3.png)

4. On the **Machines** page, select **Add/Create (1)** at the upper left, then select **Add a machine (2)** from the drop-down.

   ![](Images/Ex3-T1-S4.png)

5. On the **Add servers with Azure Arc** page, under the **Add a single server** tile, select **Generate script**.

   ![](Images/Ex3-T1-S5.png)

6. On the **Prerequisites** tab, review the requirements, then select **Next**.

   ![](Images/Ex3-T1-S6.png)

7. On the **Resource details** tab, enter the following, then select **Next**:

   - **Subscription (1)**: The lab subscription
   - **Resource group (2)**: **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Region (3)**: **Central US**
   - **Operating system (4)**: Windows
   - **Connectivity method (5)**: Public endpoint

   ![](Images/Ex3-T1-S7.png)

8. On the **Tags** tab, leave the defaults (or add tags if you wish), then select **Next**.

   ![](Images/Ex3-T1-S8.png)

9. On the **Download and run script** tab, select **Download** to save the **OnboardingScript.ps1** file. Keep this browser tab open — you will copy the script content into the on-premises VM in the next task.

   ![](Images/Ex3-T1-S9.png)

---

## Task 2: Run the script on the on-premises VM

1. In the Azure Portal, open the resource group **tailspin-<inject key="DeploymentID" enableCopy="false"/>**, then select the virtual machine **tailspin-onprem-<inject key="DeploymentID" enableCopy="false"/>-hyperv-vm**.

   > **Note:** This is the Hyper-V host VM. The on-premises server you will Arc-enable runs as a nested virtual machine (**OnPremVM**) inside this host.

   ![](Images/Ex3-T2-S1.png)

2. On the left menu, under **Operations**, select **Bastion**.

3. Enter the following credentials, then select **Connect**:

   - **Username**: demouser
   - **Password**: demo!pass123

   ![](Images/Ex3-T2-S3.png)

4. On the Hyper-V host, open the **Start** menu, then search for and open **Hyper-V Manager**.

   ![](Images/Ex3-T2-S4.png)

5. In **Hyper-V Manager**, double-click the **OnPremVM** virtual machine to open a connection to it.

   ![](Images/Ex3-T2-S5.png)

6. Sign in to **OnPremVM** using:

   - **Username**: Administrator
   - **Password**: demo!pass123

   > **Note:** If **OnPremVM** shows **No Internet Connection**, go back to the **tailspin-onprem-hyperv-vm** host, open **Network Connections**, right-click the **Ethernet** connection, select **Properties > Sharing**, and disable then re-enable **Internet Connection Sharing**. This restores internet access for the nested OnPremVM.

   ![](Images/Ex3-T2-S6.png)

7. **OnPremVM** runs an older version of Windows Server, so the Azure Connected Machine agent requires **PowerShell 5.1** and **.NET Framework 4.8**. On **OnPremVM**, open **Microsoft Edge** and download and install the following, then restart the VM:

   - **Windows Management Framework 5.1**: <https://www.microsoft.com/download/details.aspx?id=54616>
   - **.NET Framework 4.8**: <https://dotnet.microsoft.com/download/dotnet-framework/net48>

   > **Note:** If the .NET Framework 4.8 installer reports missing prerequisite updates on the older OS, install the required servicing (KB) updates it lists, restart, then run the .NET Framework installer again.

8. On **OnPremVM**, open **Windows PowerShell ISE as Administrator** (right-click > Run as administrator), then create a **New** script file.

   ![](Images/Ex3-T2-S8.png)

9. Switch to the Azure Portal browser tab from Task 1 and copy the full contents of the generated **OnboardingScript.ps1**. Paste it into the PowerShell ISE script window on **OnPremVM**.

   > **Note:** To paste into the nested VM, use the Hyper-V connection window's **Clipboard > Type clipboard text** menu if a normal paste doesn't work.

   ![](Images/Ex3-T2-S9.png)

10. Run the script (press **F5** or select the green **Run** button). The script downloads and installs the Azure Connected Machine agent, then opens a browser window to authenticate.

    > **Note:** In the authentication window, sign in with an **organization (work) account** that has permission to create Azure Arc machine resources. A personal account is not supported and results in an **AZCM0042** error.

    ![](Images/Ex3-T2-S10.png)

11. When the script finishes successfully, it displays a **Connected machine to Azure** message along with the Azure resource URL for the newly Arc-enabled server.

    ![](Images/Ex3-T2-S11.png)

---

## Task 3: Verify the Azure Arc-enabled server

1. In the Azure Portal, open the resource group **tailspin-<inject key="DeploymentID" enableCopy="false"/>**. Locate the resource of type **Machine - Azure Arc** and select it.

   ![](Images/Ex3-T3-S1.png)

2. On the **Machine - Azure Arc** overview, confirm the **Status** shows **Connected**. Notice the **Computer name** and **Operating system** are also displayed, confirming Azure can now see details about the on-premises server.

   ![](Images/Ex3-T3-S2.png)

3. Explore the left menu. Options such as **Extensions**, **Policies**, and **Inventory** show that the on-premises server can now be managed the same way as a native Azure VM.

   ![](Images/Ex3-T3-S3.png)

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="00000000-0000-0000-0000-000000000003" />

## 🧾 Summary

In this exercise, you accomplished the following:

- Generated an Azure Arc onboarding script from the Azure Portal.
- Prepared the simulated on-premises VM and ran the onboarding script to install the Azure Connected Machine agent.
- Verified the Azure Arc-enabled server shows a **Connected** status in the Azure Portal.

## You have successfully completed the lab!

![](Images/2nct.png)

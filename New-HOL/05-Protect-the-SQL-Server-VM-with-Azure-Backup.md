# Exercise 04: Protect the SQL Server VM with Azure Backup

### Estimated Duration: 120 Minutes

## 📘 Lab Scenario

Tailspin Toys has moved its database to Azure SQL Managed Instance, but the SQL Server VM is still the machine you use to work with it. Leadership now asks a simple question: if that VM is lost or damaged, how quickly can you get it back? In this exercise you protect the VM with Azure Backup, run a backup, and restore from it.

## 📋 Overview

This exercise protects the SQL Server virtual machine using Azure Backup. You register the Recovery Services resource provider, create a Recovery Services vault, and define a backup policy that governs how often backups run and how long they are kept. You then trigger an on-demand backup, restore the VM's disks from that recovery point, and finally remove the backup configuration so the resource group can be cleaned up at the end of the lab.

The only prerequisite is the SQL Server virtual machine already deployed in your **tailspin-<inject key="DeploymentID" enableCopy="false"/>** resource group.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- **Task 1:** Register the Recovery Services resource provider
- **Task 2:** Create a Recovery Services vault
- **Task 3:** Create a backup policy and enable backup
- **Task 4:** Run an on-demand backup
- **Task 5:** Restore the VM disks from a recovery point
- **Task 6:** Clean up the backup configuration

## Task 1: Register the Recovery Services resource provider

In this task, you confirm that the subscription have create Recovery Services vaults, which is a one-time requirement before Azure Backup can be used.

1. In the Azure portal, search for **Subscriptions** and select the subscription.

    ![](img/Lab04/img1.png)

1. Select the existing subscription used by this lab.

    ![](img/Lab04/img2.png)

1. Under **Settings (1)**, select **Resource providers (2)**. Search for **Microsoft.RecoveryServices (3)**, and verify that the status is **Registered (4)**.

    ![](img/Lab04/img3.png)

## Task 2: Create a Recovery Services vault

In this task, you create the Recovery Services vault that will store the SQL Server VM's backups.

1. In the Azure portal, search for **Recovery Services vaults (1)** and select **Recovery Services vaults (2)**

    ![](img/Lab04/img4.png)

1. On the **Recovery Services vaults** page, select **+ Create**.

    ![](img/Lab04/img5.png)

1. Enter the following details, select **Review + create (5)**, and then select **Create**:

   - **Subscription (1):** Use the default subscription
   - **Resource group (2):** **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Vault name (3):** **rsv-tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Region (4):** Central US

   ![](img/Lab04/img6.png)

1. When the deployment completes, select **Go to resource**.

    ![](img/Lab04/img7.png)

1. On the Recovery Services vault page, under **Settings (1)**, select **Properties (2)**. Under **Backup Configuration**, select **Update (3)**.

    ![](img/Lab04/img8.png)

1. On the **Backup Configuration** pane, set **Storage replication type** to **Locally-redundant (1)**, and select **Apply (2)**.

    ![](img/Lab04/img10.png)

    > **Note:** The replication type must be set before the first item is protected. It cannot be changed afterwards.

## Task 3: Create a backup policy and enable backup

In this task, you define how often backups run and how long they are kept, and then apply that policy to the SQL Server VM.

1. In the vault, under **Manage (1)**, select **Backup policies (2)**.

    ![](img/Lab04/img11.png)

1. Click on **+ Add**.

    ![](img/Lab04/img12.png)

1. On the **Select policy type** pane, select **Azure Virtual Machine**.

    ![](img/Lab04/img9.png)

1. Enter the following details, and then select **Create (6)**:
   - **Policy sub type (1):** Standard
   - **Policy name (2):** **policy-tailspin-daily**
   - **Backup schedule (3):** Daily, at a time of your choice
   - **Instant restore (4):** Retain instant recovery snapshots for **2** days
   - **Retention of daily backup point (5):** **7** days

   ![](img/Lab04/img14.png)

1. In the vault, under **Getting Started**, select **Backup (1)**. Set **Where is your workload running? (2)** to **Azure** and **What do you want to back up? (3)** to **Virtual machine**, and then select **Backup (4)**.

    ![](img/Lab04/img15.png)

1. Under **Policy sub type**, select **Standard**, and then choose **policy-tailspin-daily**.

    ![](img/Lab04/img13.png)

1. Under the **Virtual machines** section, select **Add**.

    ![](img/Lab04/img16.png)

1. Select the **SQL Server VM (1)**, and then select **OK (2)**.

    ![](img/Lab04/img17.png)

1. Select **Enable backup**.

    ![](img/Lab04/img18.png)

## Task 4: Run an on-demand backup

In this task, you trigger an immediate backup instead of waiting for the daily schedule, so you have a recovery point to restore from in Task 5.

1. In the vault, under **Protected items (1)**, select **Backup items (2)**, and then select **Azure Virtual Machine (3)**.

    ![](img/Lab04/img19.png)

1. Select the SQL Server VM, and then select **View Details**.

    ![](img/Lab04/img20.png)

1. On the details page, review the backup details, and then select **Backup now**.

    ![](img/Lab04/img21.png)

1. Keep the default retention date, and then select **OK**.

    ![](img/Lab04/img22.png)

1. Under **Monitoring (1)**, select **Backup jobs (2)**.

    ![](img/Lab04/img23.png)

1. On the **Backup jobs** page, select the currently running job, and then select **View details**.

    ![](img/Lab04/img24.png)

1. On the backup details page, review the progress, and wait for the process to complete.

    ![](img/Lab04/img25.png)

    > **Note:** The first backup is a full backup, so the **Transfer data to vault** subtask can take an hour or more. You do not need to wait for it. As soon as **Take Snapshot** shows **Completed**, a recovery point is available and you can continue with Task 5.

## Task 5: Restore the VM disks from a recovery point

In this task, you restore the VM's disks from the recovery point you just created, without touching the original VM.

1. In the left pane of the Recovery Services vault, go to **Backup items**.

    ![](img/Lab04/img26.png)

1. Select **Azure Virtual Machine**.

    ![](img/Lab04/img27.png)

1. Select the SQL Server VM, and then select **View Details**.

    ![](img/Lab04/img20.png)

1. On the details page, review the VM's backup details, and then select **Restore VM**.

    ![](img/Lab04/img28.png)

1. On the **Restore Virtual Machine** page, under **Restore point**, select **Select (1)**. On the **Select restore point** pane, select the desired restore point **(2)**, and then select **OK (3)**. Finally, select **Restore (4)**.

    ![](img/Lab04/img29.png)

1. Enter the following details, and then select **Restore (6)**:

    - **Restore target (1):** Create new
    - **Restore type (2):** Restore disks
    - **Subscription (3):** Select the appropriate subscription
    - **Resource group (4):** **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
    - **Staging location (5):** Select the appropriate storage account

    ![](img/Lab04/img30.png)

1. Follow the restore job **(2)** under **Backup jobs**.

    ![](img/Lab04/img31.png)

1. When the job completes, open the **tailspin-<inject key="DeploymentID" enableCopy="false"/> (1)** resource group and confirm that new managed disks have appeared next to the original VM disks **(2)**.

    ![](img/Lab04/img32.png)

    > **Note:** Restoring disks rather than a full VM keeps the original VM untouched and avoids extra compute cost. The restored disks can be attached to a new or existing VM when you need them.

## Task 6: Clean up the backup configuration

A vault that still holds backup data cannot be deleted, and this blocks the clean-up of the resource group. Remove the backup data before you finish.

1. Go to **Backup items**, then **Azure Virtual Machine**, and select the SQL Server VM.

    ![](img/Lab04/img33.png)

1. Select **Stop backup**.

    ![](img/Lab04/img34.png)

1. Choose **Delete Backup Data**, enter the VM name to confirm, select a reason, and then select **Stop backup**.

    ![](img/Lab04/img35.png)

1. Wait until the operation finishes under **Backup jobs**, and confirm that **Backup items** no longer lists the VM.

    ![](img/Lab04/img36.png)

## 🧾 Summary

In this exercise, you have accomplished the following:

* Registered the Recovery Services resource provider in the subscription
* Created a Recovery Services vault and set its storage replication type to locally-redundant
* Created a daily backup policy with instant restore and 7-day retention, and enabled backup on the SQL Server VM
* Ran an on-demand backup and monitored the backup job
* Restored the VM disks from a recovery point without affecting the original VM
* Cleaned up the backup configuration so the resource group can be removed at the end of the lab

## ✅ Conclusion

In this lab, you explored how to plan and carry out a hybrid migration with Windows Server and SQL Server on Azure. You migrated the WideWorldImporters database to Azure SQL Managed Instance using Azure Database Migration Service, and learned why the online method was used. You created a Windows Server 2025 Datacenter: Azure Edition virtual machine for the web application, accessed it securely through Azure Bastion, and confirmed its private connection to the migrated database. You connected an on-premises server to Azure using Azure Arc, so it can be managed alongside your Azure resources. Finally, you protected the SQL Server virtual machine with Azure Backup and proved the backup works by restoring from it. Through these exercises, you gained practical skills in database migration, secure connectivity, hybrid management, and backup and recovery.

### 🎉 Congratulations! You have successfully completed the Hands-on lab.
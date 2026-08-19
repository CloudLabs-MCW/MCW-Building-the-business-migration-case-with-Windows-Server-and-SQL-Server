# Exercise 1: SQL database migration

### Estimated Duration: 90 Minutes

## 📘 Lab Scenario

Tailspin Toys needs to migrate their on-premises SQL Server database to Azure SQL Managed Instance as part of the migration strategy to move Tailspin Toys workloads to Azure. In this exercise, you will take a backup of the on-premises **WideWorldImporters** database, upload it to Azure Blob Storage, and then migrate it into a pre-provisioned Azure SQL Managed Instance using **Azure Database Migration Service (DMS)** from the Azure Portal.

## 📋 Overview

In this exercise, you migrate a database from a simulated on-premises SQL Server to a fully managed Azure SQL Managed Instance. You will first review how the target Managed Instance is created, then back up the source database and place that backup in Azure Blob Storage, and finally use Azure Database Migration Service to restore the backup into the Managed Instance and complete the migration.

> **Note:** Older versions of this lab used the **Data Migration Assistant (DMA)** and the **Azure SQL Migration extension for Azure Data Studio**. Both tools were retired by Microsoft on **February 28, 2026**. This exercise uses **Azure Database Migration Service (DMS)** directly from the Azure Portal, which is the current supported path. The migration result is identical: the WideWorldImporters database ends up running on Azure SQL Managed Instance.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- **Task 1**: Review creation of Azure SQL Managed Instance **(Read-Only)**
- **Task 2**: Register the Microsoft.DataMigration resource provider
- **Task 3**: Back up the WideWorldImporters database
- **Task 4**: Upload the backup to Azure Blob Storage
- **Task 5**: Create an Azure Database Migration Service instance
- **Task 6**: Migrate the database to Azure SQL Managed Instance
- **Task 7**: Verify the migrated database

---

## Task 1: Review creation of Azure SQL Managed Instance **(Read-Only)**

> **Note:** This is a **Read-Only** task. Creating a new Azure SQL Managed Instance can take up to **6 hours**, so a Managed Instance named **sqlmi-<inject key="DeploymentID" enableCopy="false"/>** has **already been created for you**. Just read through this task to understand how it is created, then move on to Task 2.

The Managed Instance in this lab was created with the following configuration:

1. From the Azure Portal home page, select **Create a resource**, search for **azure sql managed instance**, and select **Create**.

   ![](img/Lab01/img4.png)

   ![](img/Lab01/img5.png)

2. On the **Basics** tab, the following values were used:

   - **Subscription**: The lab subscription
   - **Resource group**: **sqlvm-<inject key="DeploymentID" enableCopy="false"/>**
   - **Managed Instance name**: **sqlmi-<inject key="DeploymentID" enableCopy="false"/>**
   - **Region**: **Central US**
   - **Compute + storage**: General Purpose, 4 vCores, 32 GB

   ![](img/Lab01/img6.png)

3. Keep all the things default and click on **Review + create** and then **Create**

   ![](img/Lab01/img7.png)

   >**Note:** The instance was then reviewed and created. Because this takes several hours, it has already been completed for you.

---

## Task 2: Back up the WideWorldImporters database

In this task, you connect to the on-premises SQL Server virtual machine and create a full backup of the WideWorldImporters database using SQL Server Management Studio (SSMS).

1. In the Azure Portal, open the resource group **ODL-tailspin-<inject key="DeploymentID" enableCopy="false"/>-tailspin**, then select the virtual machine named **tailspin-onprem-<inject key="DeploymentID" enableCopy="false"/>-sql-vm**.

   > **Note:** This is the simulated on-premises SQL Server that holds the source database.

   ![](img/Lab01/img8.png)

2. On the left menu, under **Connect**, select **Bastion**.

   ![](img/Lab01/img9.png)

3. Enter the following credentials, then select **Connect**:

   - **Username**: demouser
   - **Password**: demo!pass123

   ![](img/Lab01/img10.png)

4. A new browser tab opens with the VM desktop. On the VM, open the **Start** menu, type **SQL Server Management Studio**, and open it.

   ![](img/Lab01/img11.png)

5. In the **Connect to Server** dialog, enter the following, then select **Connect**:

   - Server name: **localhost (1)** 
   - Authentication: **Windows Authentication (2)**
   - Trust Server Certificate: **Checked (3)**
   - Click on: **Connect (4)**

   ![](img/Lab01/img12.png)

6. In **Object Explorer** on the left, expand **Databases**. You should see the **WideWorldImporters** database.

   ![](img/Lab01/img13.png)


   > **Note:** If you do **not** see the **WideWorldImporters** database under **Databases**, it means the source database has not been restored on this VM yet. Follow steps **6a to 6d** below to restore it, then continue with step 7. If the database is already present, skip directly to step 7.

   6a. In the 
   

7. Right-click the **WideWorldImporters** database, select **Tasks (1)**, then select **Back Up... (2)**.

   ![](Images/BM-Ex1-T3-S7.png)

8. In the **Back Up Database** window, confirm the following, then note the file path shown under **Destination** and select **OK**:

   - **Backup type**: Full
   - **Backup component**: Database

   ![](Images/BM-Ex1-T3-S8.png)

9. When the backup completes, a message reads **The backup of database 'WideWorldImporters' completed successfully.** Select **OK**.

   > **Note:** The backup file (`WideWorldImporters.bak`) is saved in the default SQL backup folder, typically `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\`. Note this location for the next task.

   ![](Images/BM-Ex1-T3-S9.png)

---

## Task 4: Upload the backup to Azure Blob Storage

Azure Database Migration Service reads the source backup from an Azure Storage blob container. In this task, you upload the `.bak` file to the **sql-backup** container using Azure Storage Explorer.

1. On the **tailspin-onprem-sql-vm** virtual machine, open **Microsoft Edge** and go to the following URL to download **Azure Storage Explorer**:

   <https://go.microsoft.com/fwlink/?linkid=2216182>

   ![](Images/BM-Ex1-T4-S1.png)

2. Run the downloaded installer, accept the license agreement, keep the default options, and complete the installation. Launch **Microsoft Azure Storage Explorer** when done.

   ![](Images/BM-Ex1-T4-S2.png)

3. In Azure Storage Explorer, select the **account management** (person) icon on the left, then select **Sign in with Azure** and sign in with your lab credentials:

   - **Username**: <inject key="AzureAdUserEmail"></inject>
   - **Password**: <inject key="AzureAdUserPassword"></inject>

   ![](Images/BM-Ex1-T4-S3.png)

4. In the left **Explorer** pane, expand your subscription, expand **Storage Accounts**, expand the account named similar to **tailspinsql...**, then expand **Blob Containers** and select the **sql-backup** container.

   ![](Images/BM-Ex1-T4-S4.png)

5. Because DMS requires each database's backups to be in their own folder, select **New Folder** in the container and name it **WideWorldImporters**. Open that folder.

   > **Note:** DMS expects the backup files for each database to be in a dedicated folder inside the blob container.

   ![](Images/BM-Ex1-T4-S5.png)

6. Select **Upload (1)**, then **Upload Files... (2)**.

   ![](Images/BM-Ex1-T4-S6.png)

7. Browse to the backup file `WideWorldImporters.bak` created in Task 3, then select **Upload**.

   ![](Images/BM-Ex1-T4-S7.png)

8. When the upload completes, confirm the `WideWorldImporters.bak` file appears in the **WideWorldImporters** folder inside the **sql-backup** container.

   ![](Images/BM-Ex1-T4-S8.png)

---

## Task 5: Create an Azure Database Migration Service instance

In this task, you create the Azure Database Migration Service instance that orchestrates the migration.

1. In the Azure Portal, in the top **Search** bar, type **Azure Database Migration Services (1)** and select it from the results **(2)**.

   ![](Images/BM-Ex1-T5-S1.png)

2. Select **+ Create**.

   ![](Images/BM-Ex1-T5-S2.png)

3. On the **Create Migration Service** > **Basics** tab, enter the following, then select **Review + create**:

   - **Subscription**: The lab subscription
   - **Resource group**: **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Migration service name**: **tailspin-sql-migration**
   - **Location**: **Central US**

   > **Note:** Create the migration service in the **same region (Central US)** as the storage account and the Managed Instance.

   ![](Images/BM-Ex1-T5-S3.png)

4. Select **Create** and wait for the deployment to finish (this takes a few minutes).

   ![](Images/BM-Ex1-T5-S4.png)

---

## Task 6: Migrate the database to Azure SQL Managed Instance

In this task, you use the Database Migration Service to restore the backup into the Managed Instance and complete the migration.

1. Once deployment completes, select **Go to resource** to open the **tailspin-sql-migration** service.

   ![](Images/BM-Ex1-T6-S1.png)

2. On the **Overview** pane of the migration service, select **New migration**.

   ![](Images/BM-Ex1-T6-S2.png)

3. On the **Select new migration scenario** page, set the following, then select **Select**:

   - **Source server type**: SQL Server
   - **Target server type**: Azure SQL Managed Instance
   - **Backup file storage location**: Azure Storage blob container
   - **Migration mode**: Online migration

   ![](Images/BM-Ex1-T6-S3.png)

4. On the **Source details** tab, enter the connection details for the source SQL Server, then select **Next**:

   - **Source server**: The private IP address of **tailspin-onprem-sql-vm** (found on the VM's **Networking** page in the portal)
   - **Authentication type**: SQL Authentication
   - **Username**: sa
   - **Password**: demo!pass123

   > **Note:** Because the backups are already in an Azure blob container, you do **not** need a self-hosted integration runtime for this migration.

   ![](Images/BM-Ex1-T6-S4.png)

5. On the **Target details** tab, select the following, then select **Next**:

   - **Subscription**: The lab subscription
   - **Resource group**: **sqlvm-<inject key="DeploymentID" enableCopy="false"/>**
   - **Target Azure SQL Managed Instance**: **sqlmi-<inject key="DeploymentID" enableCopy="false"/>**
   - **Managed Instance admin username**: demouser
   - **Managed Instance admin password**: The Managed Instance admin password

   ![](Images/BM-Ex1-T6-S5.png)

6. On the **Database backup location** tab, provide the blob details where you uploaded the backup, then select **Next**:

   - **Resource group**: **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Storage account**: **tailspinsql...**
   - **Blob container**: **sql-backup**

   ![](Images/BM-Ex1-T6-S6.png)

7. On the **Databases to migrate** tab, select the **WideWorldImporters** database, confirm the target database name is **WideWorldImporters**, then select **Next**.

   ![](Images/BM-Ex1-T6-S7.png)

8. On the **Summary** tab, review all settings, then select **Start migration**.

   ![](Images/BM-Ex1-T6-S8.png)

9. The migration begins. Select the **WideWorldImporters** migration to open the monitoring page and watch the progress.

   ![](Images/BM-Ex1-T6-S9.png)

10. Wait until **Currently restoring files** shows **All backups restored**, then select **Complete cutover** at the top of the monitoring page.

    ![](Images/BM-Ex1-T6-S10.png)

11. In the **Complete cutover** pane, select the confirmation checkbox stating there are no additional log backups to provide, then select **Complete cutover**.

    ![](Images/BM-Ex1-T6-S11.png)

12. When the cutover finishes, the migration status changes to **Succeeded**.

    ![](Images/BM-Ex1-T6-S12.png)

---

## Task 7: Verify the migrated database

In this task, you confirm the WideWorldImporters database is online on the Managed Instance.

1. In the Azure Portal top **Search** bar, type **SQL managed instances (1)** and select it **(2)**.

   ![](Images/BM-Ex1-T7-S1.png)

2. Select the **sqlmi-<inject key="DeploymentID" enableCopy="false"/>** Managed Instance.

   ![](Images/BM-Ex1-T7-S2.png)

3. On the left menu, under **Settings**, select **SQL databases**. Confirm the **WideWorldImporters** database is listed with a status of **Online**.

   ![](Images/BM-Ex1-T7-S3.png)

> **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
> - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task.
> - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
> - If you need any assistance, please contact us at cloudlabs-support@spektrasystems.com. We are available 24/7 to help you out.

<validation step="00000000-0000-0000-0000-000000000001" />

## 🧾 Summary

In this exercise, you accomplished the following:

- Reviewed how the target Azure SQL Managed Instance is provisioned.
- Registered the Microsoft.DataMigration resource provider.
- Backed up the on-premises WideWorldImporters database using SSMS.
- Uploaded the backup to an Azure Blob Storage container.
- Created an Azure Database Migration Service instance.
- Migrated the database to Azure SQL Managed Instance and completed the cutover.
- Verified the migrated database is online.

## You have successfully completed this exercise. Click **Next >>** to proceed with the next exercise.

![](Images/2nct.png)

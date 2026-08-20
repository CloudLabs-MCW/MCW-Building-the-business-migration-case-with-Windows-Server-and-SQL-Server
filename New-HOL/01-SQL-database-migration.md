# Exercise 1: SQL database migration

### Estimated Duration: 120 Minutes

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
- **Task 6**: Assigning roles to the user and the managed identity
- **Task 7**: Migrate the database to Azure SQL Managed Instance
- **Task 8**: Verify the migrated database

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


   > **Note:** If you do **not** see the **WideWorldImporters** database under **Databases**, it means the source database has not been restored on this VM yet. Follow steps below to restore it, then continue with step 7. If the database is already present, skip directly to step 7.

   -  On the toolbar, click on the **New Query** button **(1)**.
   
   -  In the blank query editor **(2)** that opens, copy and paste the following
   T-SQL script.

   ```sql
   CREATE TABLE #fl (
    LogicalName nvarchar(128), PhysicalName nvarchar(260), [Type] char(1),
    FileGroupName nvarchar(128), Size numeric(20,0), MaxSize numeric(20,0),
    FileID bigint, CreateLSN numeric(25,0), DropLSN numeric(25,0), UniqueID uniqueidentifier,
    ReadOnlyLSN numeric(25,0), ReadWriteLSN numeric(25,0), BackupSizeInBytes bigint,
    SourceBlockSize int, FileGroupID int, LogGroupGUID uniqueidentifier,
    DifferentialBaseLSN numeric(25,0), DifferentialBaseGUID uniqueidentifier,
    IsReadOnly bit, IsPresent bit, TDEThumbprint varbinary(32), SnapshotUrl nvarchar(360));
 
   INSERT #fl EXEC('RESTORE FILELISTONLY FROM DISK = N''C:\database.bak''');
 
   DECLARE @sql nvarchar(max) =
    N'RESTORE DATABASE [WideWorldImporters] FROM DISK = N''C:\database.bak'' WITH ' +
    STUFF((SELECT ', MOVE N''' + LogicalName + ''' TO N''' +
           CASE [Type] WHEN 'D' THEN 'C:\Data\WideWorldImporters.mdf'
                       ELSE 'C:\Logs\WideWorldImporters.ldf' END + ''''
           FROM #fl FOR XML PATH('')), 1, 2, '') +
    ', REPLACE, RECOVERY';
 
   EXEC sp_executesql @sql;
   DROP TABLE #fl;
   ALTER DATABASE [WideWorldImporters] SET RECOVERY FULL;
   ```
 
   > **Note:** This script reads the internal file names directly from the backup
   > file, so you do not need to look them up yourself. It places the data file in
   > **C:\Data** and the log file in **C:\Logs**.
 
   -  Click on the **Execute** button **(3)** on the toolbar, or press the **F5**
   key on your keyboard.

      ![](img/Lab01/img14.png)

   -  Wait for the query to finish. This takes one to two minutes. In the
   **Messages** pane at the bottom of the screen, you should see a message
   similar to **RESTORE DATABASE successfully processed 3210 pages**.
  
   - In **Object Explorer**, click on the **Refresh** icon and you will see the **WideWorldImposters** Database present there

      ![](img/Lab01/img15.png)
   

7. Right-click the **WideWorldImporters (1)** database, select **Tasks (2)**, then select **Back Up... (3)**.

   ![](img/Lab01/img16.png)

1.  In the  **Back Up Database** window, select the path and click on **remove** as we will add new Path for backup

      ![](img/Lab01/img17.png)

1.  Now click on **Add (1)** button then **`` C:\Backup\WideWorldImporters.bak`` (2)** Paste this path in the File name section and then click on **OK (3)**


      ![](img/Lab01/img18.png)

8. Now in the **Back Up Database** window, confirm the following, then note the file path shown under **Destination** and select **OK**:

   - Database: **WideWorldImposters (1)**
   - Backup type: **Full (2)**
   - Path: **C:\Backup\WideWorldImporters.bak (3)**
   - Click: **OK (4)**

   ![](img/Lab01/img20.png)

9. When the backup completes, a message reads **The backup of database 'WideWorldImporters' completed successfully.** Select **OK**.

   ![](img/Lab01/img19.png)

---

## Task 4: Upload the backup to Azure Blob Storage

Azure Database Migration Service reads the source backup from an Azure Storage blob container. In this task, you upload the `.bak` file to the **sql-backup** container using Azure Storage Explorer.

1. On the **tailspin-onprem-sql-vm** virtual machine, open **Microsoft Edge** and go to the following URL to download **Azure Storage Explorer**:

   ``https://go.microsoft.com/fwlink/?linkid=2216182``

   ![](img/Lab01/img22.png)

1. The following link will download the **StorageExplorer** then click on **Openfile**

   ![](img/Lab01/img21.png)

1. On the Setup Install Mode popup click on: **Install for me only (recommended)**


   ![](img/Lab01/img23.png)

2. Run the downloaded installer, accept the license agreement (1) and click on Install (2), keep the default options, and complete the installation at last click on finish to finish the installation.

   ![](img/Lab01/img24.png)

   ![](img/Lab01/img25.png)

3. In Azure Storage Explorer, select the **Sign in with Azure**

    ![](img/Lab01/img26.png)

1. On the Select Azure Environment page please Select **Azure (1)**  then click on **Next (2)**   

    ![](img/Lab01/img27.png)
1. On the Sign in Page **Select Work or school account (1)** and click on **Continue (2)**

    ![](img/Lab01/img28.png)



1. Sign in with your lab credentials:

   - **Username**: <inject key="AzureAdUserEmail"></inject>
   - **Temp access Pass**: <inject key="AzureAdUserPassword"></inject>


   ![](img/Lab01/img29.png)


1. On Sign in to all apps and websites on this device popup , Select **No, this app only**

   ![](img/Lab01/img30.png)

4. In the left **Explorer** pane, expand your subscription (1), expand **Storage Accounts**, expand the account named similar to **tailspinsql...**, then expand **Blob Containers** and select the **sql-backup (2)** container.

   ![](img/Lab01/img31.png)

6. Select **Upload (1)**, then **Directory (2)**.

   ![](img/Lab01/img32.png)

1. On the Upload Directory popup select the folder that you want to upload. 

   ![](img/Lab01/img33.png)

1. Navigate to **``C:\``**, select the **Backup (1)** folder, and click **Select Folder (2)**.

   ![](img/Lab01/img34.png)

7. Verify the selected folder is **Backup (1)**, ensure the Blob type is set to **Block Blob (2)**, and then click **Upload (3)**.

   ![](img/Lab01/img35.png)
   

8. Once the upload is complete, verify the confirmation message in the Activities window. Then confirm that the WideWorldImporters.bak file appears in the Backup folder inside the sql-backup container.

   ![](img/Lab01/img36.png)

---

## Task 5: Create an Azure Database Migration Service instance

In this task, you create the Azure Database Migration Service instance that orchestrates the migration.

1. Go to the **``https://portal.azure.com/auth/login/``** , Login with your Azure credentials.

1. In the Azure Portal, in the top **Search** bar, type **Azure Database Migration Services (1)** and select it from the results **(2)**.

   ![](img/Lab01/img37.png)

2. Select **All resources** from the left pane then click on  **+ Create**.

   ![](img/Lab01/img38.png)

1. On the **Select migration scenario and Database Migration Service** screen , Select: 

   -  **Source server type (1)**, select **SQL Server**.
   -  **Target server type (2)**, select **Azure SQL Managed Instance**.
   -  **Database Migration Service (3)**, select **Database Migration Service**.
   -  Click **Select (4)**.

   ![](img/Lab01/img39.png)

3. On the **Create Migration Service** > **Basics** tab, enter the following, then select **Review + create** then click **Create** and wait for the deployment to finish (this takes a few minutes).:

   - **Subscription**: The lab subscription
   - **Resource group**: **ODL-tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - **Migration service name**: **tailspin-sql-migration**
   - **Location**: **Central US**

   > **Note:** Create the migration service in the **same region (Central US)** as the storage account and the Managed Instance.

   ![](img/Lab01/img40.png)

4. After deployment click on **Go to Resource** button.

   ![](img/Lab01/img41.png)

## Task 6: Assigning roles to the user and the managed identity

In this task, you will assign the **Storage Blob Data Reader** role on the storage account to two identities: your lab user account and the managed identity of the Azure SQL Managed Instance. The user account needs this access to upload the database backup to the blob container, and the Managed Instance needs it so that Azure Database Migration Service can read that backup file during the migration in the next task.

1. Go to your storage account named **tailspinsql<random-string>**.

   > **Note:** The storage account name ends with a randomly generated string, so the exact name in your environment will differ from the one shown in the screenshot.

   ![](img/Lab01/img56.png)

4. On the storage account page, select **Access Control (IAM) (1)** from the left navigation pane, then select **+ Add (2)**, and click on **Add role assignment (3)**.

   ![](img/Lab01/img57.png)

### Assign the role to your lab user account

5. On the **Role** tab of the **Add role assignment** page, enter **storage blob data reader (1)** in the search box, select **Storage Blob Data Reader (2)** from the results, and then click on **Next (3)**.

   ![](img/Lab01/img58.png)

6. On the **Members** tab, ensure that **User, group, or service principal** is selected for **Assign access to**, and then click on **+ Select members (1)**.

   ![](img/Lab01/img59.png)

7. On the **Select members** pane, enter **odl_user_<inject key="DeploymentID" enableCopy="false"/> (2)** in the search box, select your user account **ODL_User <inject key="DeploymentID" enableCopy="false"/> (3)** from the results, and then click on the **Select (4)** button then click on the **Review + assign** button.

   ![](img/Lab01/img59.png)


9. On the **Review + assign** tab, review the details and click on the **Review + assign** button again to confirm the assignment.

   > **Note:** A notification confirming that the role assignment was added appears in the top-right corner of the portal. Role assignments can take up to five minutes to take effect.

- ### Assign the role to the SQL Managed Instance

1.  Back on the **Access Control (IAM)** page of the storage account, select **+ Add (1)** and click on **Add role assignment (2)** to start a second assignment.

      ![](img/Lab01/img57.png)

11. On the **Role** tab, enter **storage blob data reader (1)** in the search box, select **Storage Blob Data Reader (2)** from the results, and then click on **Next (3)**.

    ![](img/Lab01/img58.png)

12. On the **Members** tab, select **Managed identity (1)** for **Assign access to**, and then click on **+ Select members (2)**.

    ![](img/Lab01/img60.png)

13. On the **Select managed identities** pane, set the following values:

    - **Subscription**: leave the default subscription selected.

    - **Managed identity (2)**: select **SQL managed instance** from the drop-down list.

    - Under **Selected members (3)**, confirm that **sqlmi-hol** is listed.

    - Click on the **Select (4)** button, and then click on the **Review + assign (5)** button.

      ![](img/Lab01/img60.png)

    - On the **Review + assign** tab, review the details and click on the **Review + assign** button again to confirm the assignment.

>You have now granted both your lab user account and the SQL Managed Instance read access to the storage account. In the next task, you will upload the database backup to the blob container and migrate the database using Azure Database Migration Service.

## Task 7: Migrate the database to Azure SQL Managed Instance

In this task, you use the Database Migration Service to restore the backup into the Managed Instance and complete the migration.

1. Once deployment completes, select **Go to resource** to open the **tailspin-sql-migration** service.

   ![](img/Lab01/img41.png)

2. On the **Overview** pane of the migration service, select **New migration**.

   ![](img/Lab01/img42.png)

3. On the **Select new migration scenario** page, set the following, then select **Select (5)**:

   - Source server type: **SQL Server (1)**
   - Target server type: **Azure SQL Managed Instance (2)**
   - Backup file storage location: **Blob storage (3)**
   - Migration mode: **Online (4)**

   ![](img/Lab01/img43.png)

4. On the **Source details** tab, enter the details for the source SQL Server, then select **Next**:

   -  Under **Source details**, select **No** for **Is your source SQL Server instance tracked in Azure?**.

   - **Source Infrastructure Type (1)**, select **Virtual Machine**.

   - **Subscription** : Select **Default**

   - **Resource group (2)**, select the resource group containing your source SQL Server.

   - **Location (3)** : **Central US**.

   - **SQL Server Instance Name (4)** : **tailspin-onprem-sql-server**

   -  Click **Next: Select migration target (5)**.

   > **Note:** Because the backups are already in an Azure blob container, you do **not** need a self-hosted integration runtime for this migration.

   ![](img/Lab01/img44.png)

5. On the **Select migration target** tab, select the following, then select **Next**:

   - **Subscription**: The lab subscription
   - **Resource group**: keep it Default
   - **Target Azure SQL Managed Instance**: **sqlmi-prod**
   - **click on** : **Next: Data source configuration >>**

   ![](img/Lab01/img45.png)

6. On the **Data source configuration** tab, provide the blob details(1) where you uploaded the backup, then select **Next: Database migration summary >> (2)**:

   - Resource group: **ODL-tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - Storage account: **tailspinsql...**
   - Blob container: **sql-backup**
   - Folder: **Backup**
   - Target database: **WideWorldImposters**

   ![](img/Lab01/img46.png)

8. On the **Database migration Summary** tab, review all settings, then select **Start migration**.

   ![](img/Lab01/img47.png)

9. The migration begins. Select the **WideWorldImporters** migration to open the monitoring page and watch the progress.

   ![](img/Lab01/img48.png)

10. Once it is ready to cutover Click on **database** icon.

      ![](img/Lab01/img50.png)

11. In the **Complete cutover** pane, select the confirmation checkbox stating there are no additional log backups to provide, then select **Complete cutover**.

      ![](img/Lab01/img49.png)

1. On the Complete cutover plan click on **Complete cutover**

   ![](img/Lab01/img51.png)

12. When the cutover finishes, the migration status changes to **Succeeded**.

      ![](img/Lab01/img52.png)
---

## Task 8: Verify the migrated database

In this task, you confirm the WideWorldImporters database is online on the Managed Instance.

1. In the Azure Portal top **Search** bar, type **SQL managed instances (1)** and select it **(2)**.

   ![](img/Lab01/img53.png)

2. Select **SQL managed instance (1)** from the left pane then Select **sqlmi-hol (2)**

   ![](img/Lab01/img54.png)

3. On the left menu, under **Settings**, select **SQL databases**. Confirm the **WideWorldImporters** database is listed with a status of **Online**.

   ![](img/Lab01/img55.png)


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

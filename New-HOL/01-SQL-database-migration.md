# Exercise 1: SQL database migration

### Estimated Duration: 120 Minutes

## 📘 Lab Scenario

Tailspin Toys needs to migrate its on-premises SQL Server database to Azure SQL Managed Instance as part of the strategy to move Tailspin Toys workloads to Azure. In this exercise, you will take a backup of the on-premises **WideWorldImporters** database, upload it to Azure Blob Storage, and then migrate it into a pre-provisioned Azure SQL Managed Instance using **Azure Database Migration Service (DMS)** from the Azure portal.

## 📋 Overview

In this exercise, you migrate a database from a simulated on-premises SQL Server to a fully managed Azure SQL Managed Instance. You will first review how the target Managed Instance is created, then back up the source database and place that backup in Azure Blob Storage, and finally use Azure Database Migration Service to restore the backup into the Managed Instance and complete the migration.

> **Note:** Older versions of this lab used the **Data Migration Assistant (DMA)** and the **Azure SQL Migration extension for Azure Data Studio**. Both tools were retired by Microsoft on **February 28, 2026**. This exercise uses **Azure Database Migration Service (DMS)** directly from the Azure portal, which is the current supported path. The migration result is identical: the WideWorldImporters database ends up running on Azure SQL Managed Instance.

## 🎯 Objectives

In this exercise, you will complete the following tasks:

- **Task 1:** Review creation of Azure SQL Managed Instance **(Read-Only)**
- **Task 2:** Back up the WideWorldImporters database
- **Task 3:** Upload the backup to Azure Blob Storage
- **Task 4:** Assign roles to the user and the managed identity
- **Task 5:** Migrate the database to Azure SQL Managed Instance
- **Task 6:** Verify the migrated database

---

## Task 1: Review creation of Azure SQL Managed Instance **(Read-Only)**

> **Note:** This is a **Read-Only** task. Creating a new Azure SQL Managed Instance can take up to **6 hours**, so a Managed Instance named **sqlmi-hol** has already been created for you. Read through this task to understand how it is created, and then continue with Task 2.

The Managed Instance used in this lab was created with the following configuration:

1. From the Azure portal home page, select **Create a resource**, search for **azure sql managed instance**, and then select **Create**.

   ![](img/Lab01/img4.png)

   ![](img/Lab01/img5.png)

1. On the **Basics** tab, the following values were used:

   - **Subscription:** The lab subscription
   - **Resource group:** **SQLMI-SHARED-RG-PROD**
   - **Managed Instance name:** **sqlmi-hol**
   - **Region:** **Central US**
   - **Compute + storage:** General Purpose, 4 vCores, 32 GB

   ![](img/Lab01/img6.png)

1. All remaining settings were left at their default values, and then **Review + create** and **Create** were selected.

   ![](img/Lab01/img7.png)

---

## Task 2: Back up the WideWorldImporters database

In this task, you create a full backup of the WideWorldImporters database using SQL Server Management Studio (SSMS).

> **Note:** The lab virtual machine you are already working on is **tailspin-onprem-<inject key="DeploymentID" enableCopy="false"/>-sql-vm**, the simulated on-premises SQL Server that holds the source database. You do not need to connect to any other machine for this task.

1. On the lab virtual machine, click on the **Windows Start** button **(1)**, type **SQL Server Management Studio (2)**, and then select **Microsoft SQL Server Management Studio (3)** from the search results.

   > **Note:** SQL Server Management Studio can take up to a minute to open the first time you launch it.

   ![](img/Lab01/img11.png)

1. In the **Connect to Server** dialog box, enter the following values, and then select **Connect (4)**:

   - **Server type:** Database Engine
   - **Server name (1)**: **localhost**
   - **Authentication (2)**: **Windows Authentication**
   - **Trust server certificate (3)**: selected

   ![](img/Lab01/img12.png)

1. Once connected, confirm that **Object Explorer** on the left shows **localhost (SQL Server 15.0.xxxx - SQLServer\demouser)**.

   > **Note:** The `demouser` account is a member of the **sysadmin** server role, which is required to back up and restore databases.

   ![](img/Lab01/img13.png)

1. In **Object Explorer**, expand **Databases**. You should see the **WideWorldImporters** database.

   ![](img/Lab01/img13.png)

   > **Note:** If you do not see the **WideWorldImporters** database under **Databases**, the source database has not been restored on this virtual machine yet. Follow the sub-steps below to restore it, and then continue with step 5. If the database is already present, go directly to step 5.

   - On the toolbar, click on the **New Query** button **(1)**.

   - In the blank query editor **(2)** that opens, copy and paste the following T-SQL script:

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

     > **Note:** This script reads the internal file names directly from the backup file, so you do not need to look them up yourself. It places the data file in **C:\Data** and the log file in **C:\Logs**.

   - Click on the **Execute** button **(3)** on the toolbar, or press the **F5** key on your keyboard.

     ![](img/Lab01/img14.png)

   - Wait for the query to finish. This takes one to two minutes. In the **Messages** pane at the bottom of the screen, you should see a message similar to **RESTORE DATABASE successfully processed 3210 pages**.

   - In **Object Explorer**, click on the **Refresh** icon. The **WideWorldImporters** database is now listed.

     ![](img/Lab01/img15.png)

1. Right-click on the **WideWorldImporters (1)** database, select **Tasks (2)**, and then select **Back Up... (3)**.

   ![](img/Lab01/img16.png)

1. In the **Back Up Database** window, select the existing path under **Destination**, and then click on **Remove**. You will add a new path for the backup.

   > **Note:** You must remove the default destination and specify a new file. Backing up to a file that already contains a backup from a different SQL Server version fails with the error *"The Backup cannot be performed because the existing media set is formatted with an incompatible version."*

   ![](img/Lab01/img17.png)

1. Click on the **Add (1)** button, paste **`C:\Backup\WideWorldImporters.bak` (2)** into the **File name** box, and then click on **OK (3)**.

   ![](img/Lab01/img18.png)

1. Back in the **Back Up Database** window, confirm the following values, and then select **OK (4)**:

   - Database: **WideWorldImporters (1)**
   - Backup type: **Full (2)**
   - Path: **C:\Backup\WideWorldImporters.bak (3)**

   ![](img/Lab01/img20.png)

1. When the backup completes, a message reads **The backup of database 'WideWorldImporters' completed successfully**. Select **OK**.

   ![](img/Lab01/img19.png)

---

## Task 3: Upload the backup to Azure Blob Storage

Azure Database Migration Service reads the source backup from an Azure Storage blob container. In this task, you upload the `.bak` file to the **sql-backup** container using Azure Storage Explorer.

1. On the lab virtual machine, open **Microsoft Edge** and go to the following URL to download **Azure Storage Explorer**:

   ```
   https://go.microsoft.com/fwlink/?linkid=2216182
   ```

   ![](img/Lab01/img22.png)

1. When the download completes, click on **Open file**.

   ![](img/Lab01/img21.png)

1. On the **Setup - Install Mode** dialog box, select **Install for me only (recommended)**.

   ![](img/Lab01/img23.png)

1. Accept the license agreement **(1)** and click on **Install (2)**. Keep the default options, and then click on **Finish** to complete the installation. Azure Storage Explorer opens automatically.

   ![](img/Lab01/img24.png)

   ![](img/Lab01/img25.png)

1. In Azure Storage Explorer, select **Sign in with Azure**.

   ![](img/Lab01/img26.png)

1. On the **Select Azure Environment** page, select **Azure (1)**, and then click on **Next (2)**.

   ![](img/Lab01/img27.png)

1. On the sign-in page, select **Work or school account (1)**, and then click on **Continue (2)**.

   ![](img/Lab01/img28.png)

1. Sign in with your lab credentials:

   - **Username:** <inject key="AzureAdUserEmail"></inject>
   - **Temporary Access Pass:** <inject key="AzureAdUserPassword"></inject>

   ![](img/Lab01/img29.png)

1. On the **Stay signed in to all your apps** prompt, select **No, this app only**.

   ![](img/Lab01/img30.png)

1. In the left **Explorer** pane, expand your subscription **(1)**, expand **Storage Accounts**, expand **storage<inject key="DeploymentID" enableCopy="false"/>**, expand **Blob Containers**, and then select the **sql-backup (2)** container.

   ![](img/Lab01/img31.png)

1. Select **Upload (1)**, and then select **Directory (2)**.

   > **Note:** Upload the **Backup** folder, not the individual `.bak` file. Azure Database Migration Service reads the backup from a folder inside the container, and only folders one level deep are supported.

   ![](img/Lab01/img32.png)

1. On the **Upload Directory** dialog box, select the folder that you want to upload.

   ![](img/Lab01/img33.png)

1. Navigate to **`C:\`**, select the **Backup (1)** folder, and then click on **Select Folder (2)**.

   ![](img/Lab01/img34.png)

1. Verify that the selected folder is **Backup (1)**, ensure the blob type is set to **Block Blob (2)**, and then click on **Upload (3)**.

   ![](img/Lab01/img35.png)

1. When the upload completes, verify the confirmation message in the **Activities** window, and then confirm that the **WideWorldImporters.bak** file appears in the **Backup** folder inside the **sql-backup** container.

   ![](img/Lab01/img36.png)

---

## Task 4: Assign roles to the user and the managed identity

In this task, you assign the **Storage Blob Data Reader** role on the storage account to two identities: your lab user account and the managed identity of the Azure SQL Managed Instance.

1. In the Azure portal, open your storage account named **storage<inject key="DeploymentID" enableCopy="false"/>**.

   ![](img/Lab01/img56.png)

1. On the storage account page, select **Access Control (IAM) (1)** from the left navigation pane, select **+ Add (2)**, and then click on **Add role assignment (3)**.

   ![](img/Lab01/img57.png)

### Assign the role to your lab user account

1. On the **Role** tab, enter **storage blob data reader (1)** in the search box, select **Storage Blob Data Reader (2)** from the results, and then click on **Next (3)**.

   ![](img/Lab01/img58.png)

1. On the **Members** tab, ensure that **User, group, or service principal (1)** is selected for **Assign access to**, and then click on **+ Select members (2)**. On the **Select members** pane, enter **odl_user_<inject key="DeploymentID" enableCopy="false"/> (3)** in the search box, select your user account **ODL_User <inject key="DeploymentID" enableCopy="false"/> (4)** from the results, click on the **Select (5)** button, and then click on the **Review + assign (6)** button.

   ![](img/Lab01/img59.png)

1. On the **Review + assign** tab, review the details and click on the **Review + assign** button again to confirm the assignment.

   > **Note:** A notification confirming that the role assignment was added appears in the top-right corner of the portal. Role assignments can take up to five minutes to take effect.

### Assign the role to the SQL Managed Instance

1. Back on the **Access Control (IAM)** page of the storage account, select **+ Add (1)**, and then click on **Add role assignment (2)** to start a second assignment.

   ![](img/Lab01/img57.png)

1. On the **Role** tab, enter **storage blob data reader (1)** in the search box, select **Storage Blob Data Reader (2)** from the results, and then click on **Next (3)**.

   ![](img/Lab01/img58.png)

1. On the **Members** tab, select **Managed identity (1)** for **Assign access to**, and then click on **+ Select members (2)**. On the **Select managed identities** pane, set the following values:

   - **Subscription:** leave the default subscription selected.
   - **Managed identity (3)**: select **SQL managed instance** from the drop-down list.
   - Under **Selected members (4)**, confirm that **sqlmi-hol** is listed.
   - Click on the **Select (5)** button, and then click on the **Review + assign (6)** button.

   > **Note:** This second assignment is the one that matters for the migration. Azure Database Migration Service reads the backup file using the Managed Instance's identity, not yours. Without it, the migration fails at the data source configuration step.

   ![](img/Lab01/img60.png)

1. On the **Review + assign** tab, review the details and click on the **Review + assign** button again to confirm the assignment.

You have now granted both your lab user account and the SQL Managed Instance read access to the storage account.

---

## Task 5: Migrate the database to Azure SQL Managed Instance

In this task, you use Azure Database Migration Service to restore the backup into the Managed Instance and complete the migration.

1. In the Azure portal, open your resource group **tailspin-<inject key="DeploymentID" enableCopy="false"/>**, and then select the **dataMigration-<inject key="DeploymentID" enableCopy="false"/>** migration service.

   ![](img/Lab01/img41.png)

1. On the **Overview** pane of the migration service, select **New migration**.

   ![](img/Lab01/img42.png)

1. On the **Select new migration scenario** page, set the following values, and then select **Select (5)**:

   - Source server type: **SQL Server (1)**
   - Target server type: **Azure SQL Managed Instance (2)**
   - Backup file storage location: **Blob storage (3)**
   - Migration mode: **Online (4)**

   > **Note:** In **Online** mode, the migration keeps syncing until you complete the cutover, so the source database stays available throughout. The migration remains at **Ready for cutover** until you finish it in step 9.

   ![](img/Lab01/img43.png)

1. On the **Source details** tab, enter the details for the source SQL Server, and then select **Next: Select migration target (5)**:

   - Under **Source details**, select **No** for **Is your source SQL Server instance tracked in Azure?**
   - **Source Infrastructure Type (1)**: select **Virtual Machine**.
   - **Subscription:** select **Default**.
   - **Resource group (2)**: select the resource group containing your source SQL Server.
   - **Location (3)**: **Central US**
   - **SQL Server Instance Name (4)**: **tailspin-onprem-sql-server**

   > **Note:** Because the backups are already in an Azure blob container, you do not need a self-hosted integration runtime for this migration.

   ![](img/Lab01/img44.png)

1. On the **Select migration target** tab, select the following values, and then select **Next: Data source configuration >>**:

   - **Subscription:** The lab subscription
   - **Resource group:** keep the default
   - **Target Azure SQL Managed Instance:** **sqlmi-hol**

   ![](img/Lab01/img45.png)

1. On the **Data source configuration** tab, provide the blob details **(1)** for the location where you uploaded the backup, and then select **Next: Database migration summary >> (2)**:

   - Resource group: **tailspin-<inject key="DeploymentID" enableCopy="false"/>**
   - Storage account: **storage<inject key="DeploymentID" enableCopy="false"/>**
   - Blob container: **sql-backup**
   - Folder: **Backup**
   - Target database: **WideWorldImporters-<inject key="DeploymentID" enableCopy="false"/>**

   > **Note:** Make sure you enter the target database name with your deployment ID, exactly as shown above. You can copy the exact value from **Your Target Database Name** on the **Environment** tab.

   ![](img/Lab01/img46.png)

1. On the **Database migration summary** tab, review all settings, and then select **Start migration**.

   ![](img/Lab01/img47.png)

1. The migration begins. Select the **WideWorldImporters-<inject key="DeploymentID" enableCopy="false"/>** migration to open the monitoring page and watch the progress.

   ![](img/Lab01/img48.png)

1. Once the migration status shows **Ready for cutover**, click on the **database** icon.

   ![](img/Lab01/img50.png)

1. In the **Complete cutover** pane, select the confirmation checkbox stating that there are no additional log backups to provide, and then select **Complete cutover**.

   ![](img/Lab01/img49.png)

1. On the **Complete cutover** confirmation page, click on **Complete cutover**.

   ![](img/Lab01/img51.png)

1. When the cutover finishes, the migration status changes to **Succeeded**.

   ![](img/Lab01/img52.png)

---

## Task 6: Verify the migrated database

In this task, you confirm that the migrated database is online on the Managed Instance.

1. In the Azure portal **Search** bar, type **SQL managed instances (1)**, and then select it **(2)**.

   ![](img/Lab01/img53.png)

1. Select **SQL managed instance (1)** from the left pane, and then select **sqlmi-hol (2)**.

   ![](img/Lab01/img54.png)

1. On the left menu, under **Settings**, select **SQL databases**. Confirm that the **WideWorldImporters-<inject key="DeploymentID" enableCopy="false"/>** database is listed with a status of **Online**.

   ![](img/Lab01/img55.png)

## Task 7: Migration tooling and cutover planning **(Read-Only)**

> **Note:** This is a **Read-Only** task. There are no steps to perform. Read through it to understand the options available for migrating a SQL Server database to Azure, and why this lab used the one it did.

You migrated WideWorldImporters using Azure Database Migration Service in online mode. That was one of several routes available. This task covers the alternatives, when each one is appropriate, and how a real cutover is planned.

### The available migration paths

| Method | How it works | Downtime | When to use it |
| --- | --- | --- | --- |
| **Database Migration Service — offline** | Restores a full backup into the target. No further syncing takes place. | The full duration of the restore | Databases that can be taken offline for the length of the restore, such as reporting databases or anything migrated over a weekend. |
| **Database Migration Service — online** | Restores the full backup, then continuously applies log backups until you complete the cutover. | Minutes, at cutover only | Production databases that cannot be offline for hours. This is what you used in this lab. |


**Why online mode was used here.** The Tailspin Toys database backs a live e-commerce application. An offline migration would have meant taking orders offline for as long as the restore took, and that duration is not known in advance for a database of any size. Online mode restores the bulk of the data while the source stays in use, then applies only the final changes at cutover.

> **Note:** Online mode is why the migration sat at **Ready for cutover** rather than completing on its own. The service was waiting for you to decide when the switch happened. In a real migration, that decision is made by the business, not by the engineer running the tool.

### What happens at cutover

The cutover is the only moment in an online migration where the application is affected. It follows a fixed sequence:

1. **Stop application traffic to the source database.** New transactions must stop, otherwise changes made after the final backup are lost.
2. **Take the final transaction log backup** on the source and make it available to the migration service.
3. **Complete the cutover** in the portal. The service applies the final log backup and brings the target database online.
4. **Repoint the application** to the Managed Instance by updating its connection string.
5. **Verify** that the application works against the new database before allowing traffic back in.
6. **Allow application traffic to resume.**

In this lab you selected a checkbox confirming there were no further log backups to apply, because nothing was writing to the source database. In production, step 1 and step 2 are the part that requires coordination with the business, and the window is usually agreed weeks in advance.

> **Note:** The source database is not deleted at cutover. Keeping it in place, read-only, for an agreed period is normal practice. It gives the organization a way back if something is found after the switch.

### Planning the cutover window

Three things determine how long the window needs to be:

- **How long the final log backup takes to apply.** In an online migration this is usually seconds to a few minutes, because the bulk of the data was already restored.
- **How long application verification takes.** This is often the longest part, and it depends on how much of the application is tested before traffic is allowed back.
- **How long a rollback would take** if verification fails. The window has to be long enough to include a rollback, not just the migration.

A typical production cutover for a database of this size runs in the low tens of minutes, and is scheduled outside business hours.

### Tools that no longer apply

Two tools appear in older guidance and are worth knowing about, because they still turn up in search results:

- **Data Migration Assistant (DMA)** was used to assess a source database for compatibility issues before migrating. Its assessment role is now covered by Azure Migrate.
- **The Azure SQL Migration extension for Azure Data Studio** provided a desktop interface for the same Database Migration Service you used in this lab. The service itself is unchanged; only the interface was retired.

Both were retired by Microsoft on **28 February 2026**. The Azure portal experience you used in this exercise is the current supported path.

### Summary of the choice

For the Tailspin Toys migration, the decision was straightforward once the constraints were written down:

| Constraint | Consequence |
| --- | --- |
| Production database backing a live application | Offline migration ruled out |
| Backup already staged in blob storage | No self-hosted integration runtime required |
| Single database, moderate size | Managed Instance link unnecessarily complex |
| Migration needs to be auditable and repeatable | Portal-based Database Migration Service preferred over a manual restore |

The result is the path you followed: an online migration through Azure Database Migration Service, reading the backup from blob storage, with a cutover controlled by the engineer.

## 🧾 Summary

In this exercise, you accomplished the following:

- Reviewed how the target Azure SQL Managed Instance is provisioned.
- Backed up the on-premises WideWorldImporters database using SQL Server Management Studio.
- Uploaded the backup to an Azure Blob Storage container.
- Assigned the required storage roles to your user account and the Managed Instance.
- Migrated the database to Azure SQL Managed Instance and completed the cutover.
- Verified that the migrated database is online.

### You have successfully completed this exercise. Click on **Next >>** to proceed with the next exercise.

![](Images/2nct.png)
## Exercise 4: Azure Arc-enable on-premises VM

Duration: 45 minutes

In this exercise, you will Azure Arc-enable a Windows Server VM that Tailspin has on-premises. This VM is being Arc-enabled since there are no plans to migrate it to Azure, but Tailspin would like to simplify the management of all their VMs in a single place. Azure Arc provides the functionality to manage Azure and on-premises VMs in a single place giving Tailspin Toys exactly what they are looking for to simplify VM management and administration.

  [Azure Arc-enable on-premises VM](#exercise-3-azure-arc-enable-on-premises-vm)
   
   - [Task 1: Generate Azure Arc script to add server](#task-1-generate-azure-arc-script-to-add-server)
    
   - [Task 2: Run script to add server to Azure Arc](#task-2-run-script-to-add-server-to-azure-arc)
    
   - [Task 3: Verify Azure Arc-enabled VM](#task-3-verify-azure-arc-enabled-vm)

### Task 1: Generate Azure Arc script to add server

1. Sign in to the [Azure Portal](https://portal.azure.com). 

2. In the **Search resources, services, and docs** box at the top of the portal, search for **Azure Arc**, then select the **Azure Arc** service.

    ![An Azure Portal search is shown showing the results for a search for Azure Arc with the Azure Arc service in the results highlighted.](images/Ex3-T1-S2.png "Azure Portal search for Azure Arc with 'Azure Arc' option highlighted")

3. On the **Azure Arc** pane, select the **Infrastructure** tab, then select the **Add** button under **Servers**.

    ![The Azure Arc pane in the Azure Portal is shown navigated to the Infrastructure pane and the Servers Add button is highlighted.](images/Ex3-T1-S3.png "Azure Arc pane showing Infrastructure tab")

4. Under **Add a single server** select **Generate script**.

    ![The Add servers with Azure Arc pane is shown with the Generate Script button highlighted for the Add a single server option.](images/Ex3-T1-S4.png "Add servers with Azure Arc with Generate script")

5. On the **Add a server with Azure Arc** pane, read the requirements of Azure Arc that are listed, then select **Next**.

    ![The prerequisites tab is shown for the Add a server with Azure Arc pane with the requirements listed.](images/Ex3-T1-S5.png "Add a server with Azure Arc requirements")

6. On the **Resource details** tab, enter the following values, then select **Next**.

    - **Resource group**: Select the Resource Group created for this lab. For example: `tailspin-rg`.
    - **Region**: `Central US`
    - **Operating system**: `Windows`
    - **Connectivity method**: `Public endpoint`

    ![The Resource details tab of the Add a server with Azure Arc pane is displayed with values entered.](images/Ex3-T1-S6.png "Resource details tab with values entered")

7. On the **Tags** tab, enter the following tag values to identify this server, then select **Next**:

    - **Datacenter**: `headquarters`
    - **City**: `Milwaukee`
    - **StateOrDistrict**: `WI`
    - **CountryOrRegion**: `USA`

    ![The Tags tab of the Add a server with Azure Arc pane is shown with the tag values entered.](images/Ex3-T1-S7.png "Tags tab with all tag values entered")

8. On the **Download and run script** tab, select **Download** to download the generated script. By default, the script named `OnboardingScript.ps1` will be saved to the `Downloads` folder.

    ![The Download button is highlighted on the Download and run script tab.](images/Ex3-T1-S8.png "Download and run script")

### Task 2: Run script to add server to Azure Arc

1. In the Azure Portal, navigate to the Resource Group **tailspin-rg**, then select the `tailspin-onprem-hyperv-vm` virtual machine resource. This is the simulated on-premises Hyper-V host VM.

    ![The resource group for the lab is shown with the simulated on-premises Hyper-V Host VM highlighted in the resource list.](images/Ex3-T2-S1.png "Resource group with simulated on-premises Hyper-V Host VM highlighted")

2. On the left, select **Bastion** under **Operations**.

    ![The virtual machine pane for the simulated on-premises hyper-v host VM is shown with the Bastion link under Operations highlighted.](images/Ex2-T2-S2.png "Bastion link under Operations")

3. Enter the **Username** and **Password**, then select **Connect**.

    ![The Bastion pane is shown for the VM with the Username and Password values entered and fields highlighted.](images/Ex3-T2-S3.png "Bastion credentials shown entered")

    > **Note**: Credentials for logging in to the VM :
    - **Username**: `demouser`
    - **Password**: `demo!pass123`

4. Once connected to the Hyper-V Host VM, open the **Start menu**, then search for and run the **Hyper-V Manager**.

    ![Open Hyper-V.](images/Ex3-T2-S4.png "Hyper-v")

5. Within the **Hyper-V Manager**, double-click the **OnPremVM** VM to connect to it.

    ![The Hyper-V Manager is shown with the list of virtual machines displayed with the OnPremVM highlighted.](images/Ex3-T2-S5.png "Hyper-V Manager list of VMs with OnPremVM shown")

6. Once connected to the **OnPremVM** VM within Hyper-V, sign in using the **Administrator** account and the password of `demo!pass123`.

    > **Note**: If you encounter that the **OnPremVM** has **No Internet Connection**, go back into the `tailspin-onprem-hyperv-vm` Hyper-V Host VM and perform the following steps:
    > - Open the **Network Connections**
    > - Locate the **Ethernet** connection and right-click it.
    > - Select **Properties**
    > - Select the **Sharing** tab
    > - Disable and re-enable **Internet Connection Sharing** on this connection.
    >
    > You may see a warning message when disabling it and re-enabling it, but it will still work to restore Internet Connection Sharing with the **OnPremVM** that is connected through the Host VM's network connection.
    >
    > ![The Ethernet connection properties on the Hyper-V Host VM showing Internet Connection Sharing option highlighted.](images/Ex3-T2-S6.note.png "Ethernet Properties for Internet Connection Sharing")

    ![Login to Onprem VM.](images/Ex3-T2-S6.png "Admin login")
    
7. Within the **OnPremVM**, open **Internet Explorer**, go to the following link to download the Windows Update for installing **PowerShell 5.1**, and run it. This will install PowerShell 5.1 on the Windows Server 2012 R2 VM, since this is the version of PowerShell required by the Azure Arc script.

    <https://go.microsoft.com/fwlink/?linkid=839516>
    
    - Click on **Open**.
    
    ![download the Windows Update for installing PowerShell 5.1.](images/Ex3-T2-S7.png "PowerShell 5.1")
    
    - Accept the license terms by clicking on **I Accept**. 
    
    ![download the Windows Update for installing PowerShell 5.1.](images/Ex3-T2-S7.1.png "PowerShell 5.1")
    
    - On **Download and Install Updates** click on **Restart Now**.
    
    ![download the Windows Update for installing PowerShell 5.1.](images/Ex3-T2-S7.2.png "PowerShell 5.1")

8. Within the **OnPremVM**, open **Internet Explorer**, go to the following link to download the .NET Framework 4.8, and install it. The Azure Arc script will install the **Azure Connected Machine Agent** which requires **.NET Framework 4.6 or later**.

    <https://go.microsoft.com/fwlink/?LinkId=2085155>

    > **Note**: The .NET Framework installer will display a **Blocking Issues** box with a note that another update needs to be installed.
    > The following 2 updates will need to be installed in the following order:
    > - Install KB2919442 from <https://www.microsoft.com/en-us/download/details.aspx?id=42153>
    > - Install KB2919355 from <https://www.microsoft.com/en-us/download/details.aspx?id=42334>
    >
    > Be sure to restart the VM after installing the updates, before you continue with the .NET Framework install.
    >
    > ![The blocking issue warning of the .NET Framework installer is shown with the message for the blocking issue highlighted.](images/dot-net-framwork-blocking-issue.png "Blocking issue warning with message highlighted")
    - Once the **.NET Framework** is installed on **Download and Install Updates** click on **Restart Now**.
    
     ![download the Windows Update for installing .NET Framework .](images/Ex3-T2-S7.2.png ".NET Framework")

9. Within the **OnPremVM**, open the **Windows PowerShell ISE**, and create a new script file.

10. Paste in the contents of the Azure Arc `OnboardingScript.ps1` script that was previously downloaded.

    > **Note**: Within the Hyper-V Virtual Machine Connection window, you may need to use the **Clipboard** -> **Type clipboard text** menu option to paste into the **OnPremVM**.
     
     ![Run OnboardingScript.ps1 script .](images/Ex3-T2-S10.png "OnboardingScript.ps1")

11. Run the full script. This will install the Azure Arc agent and Arc-enable the VM. When the script opens up a browser window, enter your credentials to authenticate with Azure.

    > **Note**: When the Azure Arc script opens a new browser window to authenticate you with Azure, be sure to use an Organization Account with permissions to create `Microsoft.HybridCompute/machines` resources. Using a Personal Account is not supported and will result in a `AZCM0042: Failed to Create Resource` error message.
    
    ![Azure credentials login .](images/Ex3-T2-S11.png "Azure credentials")
    
    ![Azure credentials login .](images/Ex3-T2-S11.1.png "Azure credentials")

12. When the script finishes executing successfully, a message stating "**Connected machine to Azure**" will be shown, along with the Azure Portal resource URL for the Azure Arc-enabled Server.

    ![The command line output of the Azure Arc script is shown that includes the Connected machine to Azure message showing the script executed successfully.](images/Ex3-T2-S12.png "Azure Arc script successful with Connected machine to Azure message")

### Task 3: Verify Azure Arc-enabled VM

1. In the Azure Portal, navigate to the Resource Group for the lab. Scroll down and locate the Azure resource of type **Server - Azure Arc** and select it.

    ![The tailspin-rg Resource group for the lab is shown in the Azure Portal.](images/Ex3-T3-S1.png "tailspin-rg resource group")

    > **Note**: The on-premises VM has been Azure Arc-enabled and can be managed alongside other Azure resources. This is enabled by the **Azure Connected Machine Agent** running on the VM that facilitates the interaction between Azure and the Azure Arc-enabled VM.

2. This is the **Server - Azure Arc** pane for the on-premises virtual machine that was just Azure Arc-enabled. The **Status** shows **Connected** to signify that the Azure Arc-enabled virtual machine is connected to Azure. Also, notice that the **Computer Name** and **Operating System** of the virtual machine are displayed.

    ![The Server - Azure Arc pane in the Azure Portal is shown for the on-premises VM with status, computer name, and operating system values highlighted within the Essentials section.](images/Ex3-T3-S2.png "Azure Portal Server - Azure Arc pane for Azure Arc-enabled virtual machine")

3. From here, there are several **Azure Arc** capabilities available to use for managing the Azure Arc-enabled virtual machine.

    ![The Capabilities section of the Server- Azure Arc pane is shown with the list of capabilities to choose from.](images/Ex3-T3-S3.png "Azure Arc capabilities listed on the Server - Azure Arc pane")

4. Select **Extensions** under **Settings**. This is where you can install Extensions on the Azure Arc-enabled virtual machine. For example, the **Custom Script Extension for Windows - Azure Arc** extension can be used to download PowerShell scripts and files from Azure storage, and launch a PowerShell script on the machine.

    ![The Extensions pane for the Server - Azure Arc resource is shown with the Extensions link under Settings highlighted.](images/Ex3-T3-S4.png "Azure Portal Server - Azure Arc pane showing Extensions")

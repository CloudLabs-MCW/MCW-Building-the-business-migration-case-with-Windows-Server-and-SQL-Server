<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - create-vm.ps1

.What does this script do?  
 - Creates an Internal Switch in Hyper-V called "Nat Switch"
    
 - Downloads an Image of an Ubuntu Linux 16.04 Server to the local drive

 - Add a new IP address to the Internal Network for Hyper-V attached to the NAT Switch

 # - Creates a NAT Network on 192.168.0.0/24

 - Creates the Virtual Machine in Hyper-V

 - Issues a Start Command for the new "OnPremVM"
#>

Configuration Main
{
	Import-DscResource -ModuleName 'PSDesiredStateConfiguration', 'xHyper-V'

	node "localhost"
  	{
		# Ensures a VM with default settings
        xVMSwitch InternalSwitch
        {
            Ensure         = 'Present'
            Name           = 'Nat Switch'
            Type           = 'Internal'
        }
		
		Script ConfigureHyperV
    	{
			GetScript = 
			{
				@{Result = "ConfigureHyperV"}
			}	
		
			TestScript = 
			{
           		return $false
        	}	
		
			SetScript =
			{
                mkdir "C:\git"
                cd "C:\git"
                $vmFolder = "C:\git"
   			    $zipUrl = "https://storagetemp109.blob.core.windows.net/businessmigrate/OnPremWinServerVM.zip"
   			     $downloadPath = "C:\git\OnPremWinServerVM.zip"

  				 Write-Output "Downloading VM package from Azure Storage..."
   				 Invoke-WebRequest -Uri $zipUrl -OutFile $downloadPath

   				 Write-Output "Extracting VM package..."
   				 Add-Type -AssemblyName "System.IO.Compression.FileSystem"
   				 [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, $vmFolder)
				 
                 $NatSwitch = Get-NetAdapter -Name "vEthernet (NAT Switch)"
                New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex $NatSwitch.ifIndex

                New-NetNat -Name NestedVMNATnetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24 -Verbose

                New-VM -Name OnPremVM `
                        -MemoryStartupBytes 4GB `
                        -BootDevice VHD `
                        -VHDPath 'C:\VM\WinServer\Virtual Hard Disks\WinServer.vhdx' `
                        -Path 'C:\VM\WinServer\Virtual Hard Disks' `
                        -Generation 1 `
                        -Switch "NAT Switch"

                Start-VM -Name OnPremVM
			}
		}	
  	}
}

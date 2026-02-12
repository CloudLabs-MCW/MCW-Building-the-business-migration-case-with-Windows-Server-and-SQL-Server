<#
Microsoft Cloud Workshop: BCDR
File Name: create-vm.ps1

Updated to work with Azure DSC VM Extension
- Creates an Internal Switch in Hyper-V called "Nat Switch"
- Adds IP to NAT switch and creates NAT network
- Creates a VM using a VHD included in the DSC zip package
- Starts the VM
#>

Configuration Main
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration', 'xHyper-V'

    node "localhost"
    {
        # Ensure Internal NAT switch exists
        xVMSwitch InternalSwitch
        {
            Ensure = 'Present'
            Name   = 'Nat Switch'
            Type   = 'Internal'
        }

        Script ConfigureHyperV
        {
            GetScript = { @{ Result = "ConfigureHyperV" } }

            TestScript = { return $false }

            SetScript = {

                # DSC extension extracts zip to its working folder
                $vmFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
                Write-Output "Working folder: $vmFolder"

                # Download URL only needed if not already in zip
                # For DSC extension, the zip already contains scripts + VHD
                # $zipUrl = "https://<your-sas-url>/OnPremWinServerVM.zip"
                # $downloadPath = Join-Path $vmFolder "OnPremWinServerVM.zip"
                # Invoke-WebRequest -Uri $zipUrl -OutFile $downloadPath -UseBasicParsing
                # [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, $vmFolder)

                # Configure NAT switch IP
                $natSwitch = Get-NetAdapter -Name "vEthernet (Nat Switch)"
                if (-not (Get-NetIPAddress -InterfaceIndex $natSwitch.ifIndex -ErrorAction SilentlyContinue)) {
                    New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex $natSwitch.ifIndex
                }

                # Create NAT network if not exists
                if (-not (Get-NetNat -Name "NestedVMNATnetwork" -ErrorAction SilentlyContinue)) {
                    New-NetNat -Name "NestedVMNATnetwork" -InternalIPInterfaceAddressPrefix 192.168.0.0/24 -Verbose
                }

                # VHD path relative to DSC extraction folder
                $vhdPath = Join-Path $vmFolder "WinServer.vhdx"
                if (-not (Test-Path $vhdPath)) {
                    throw "VHD not found at $vhdPath. Ensure it is included in the DSC zip package."
                }

                # Create VM if not exists
                if (-not (Get-VM -Name "OnPremVM" -ErrorAction SilentlyContinue)) {
                    New-VM -Name "OnPremVM" `
                           -MemoryStartupBytes 4GB `
                           -BootDevice VHD `
                           -VHDPath $vhdPath `
                           -Generation 1 `
                           -Switch "Nat Switch"
                    Write-Output "VM 'OnPremVM' created."
                } else {
                    Write-Output "VM 'OnPremVM' already exists."
                }

                # Start VM if not running
                $vm = Get-VM -Name "OnPremVM"
                if ($vm.State -ne "Running") {
                    Start-VM -Name "OnPremVM"
                    Write-Output "VM 'OnPremVM' started."
                } else {
                    Write-Output "VM 'OnPremVM' is already running."
                }
            }
        }
    }
}

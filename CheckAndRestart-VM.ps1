#Powershell HyperV VM-Check for Solarwinds RMM
#Author: Andreas Walker andreas.walker@walkerit.ch
#Licence: GNU General Public License v3.0
#Version: 1.0.0 / 20.10.2019

#Define paremeter
Param (
[string]$VM,
$Start = 'no'
)

#Get status of selected VM
$VMStatus = Get-VM | where {$_.Name -eq $VM}

#Check Status of selected VM
if ($VMStatus.State -like "Running")
    {
    Write-Host "OK - VM $VM is running for"$VMStatus.Uptime
    Exit 0
    }
    else
        {
        Write-Host "Error - VM $VM is not running"
        if ($Start -eq 'no')
            {
            Exit 1001
            }
            else
                {
                Write-Host "Trying to Start VM $VM"
                Start-VM -Name $VM
                Start-Sleep -Seconds 60
                $NewVMStatus = Get-VM | where {$_.Name -eq $VM}
                if ($VMStatus.State -like "Running")
                    {
                    Write-Host "VM $VM is running now"
                    Exit 0
                    }
                    else
                        {
                        Write-Host "VM $VM is still not running"
                        Exit 1001
                        }
                }
        }

#Catch unexpected end of Script
Write-Host "FAILURE - Script ended unexpected"
Exit 1001
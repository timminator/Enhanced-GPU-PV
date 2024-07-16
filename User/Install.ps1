﻿param(
$team_id,
$key
)

while(!(Test-NetConnection Google.com).PingSucceeded){
    Start-Sleep -Seconds 1
    }

Get-ChildItem -Path C:\ProgramData\Easy-GPU-P -Recurse | Unblock-File

# Install Parsec and add config file entries
if (Test-Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Parsec) 
    {}
    else {
    (New-Object System.Net.WebClient).DownloadFile("https://builds.parsecgaming.com/package/parsec-windows.exe", "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe")
    Start-Process "C:\Users\$env:USERNAME\Downloads\parsec-windows.exe" -ArgumentList "/silent", "/shared","/team_id=$team_id","/team_computer_key=$key" -wait
    While (!(Test-Path C:\ProgramData\Parsec\config.txt)){
        Start-Sleep -s 1
        }
    $configfile = Get-Content C:\ProgramData\Parsec\config.txt
    $configfile += "host_virtual_monitor_fallback = false"
    $configfile += "host_virtual_mouse = 0"
    $configfile += "host_virtual_microphone = 0"
    $configfile | Out-File C:\ProgramData\Parsec\config.txt -Encoding ascii
    Copy-Item -Path "C:\ProgramData\Easy-GPU-P\Parsec.lnk" -Destination "C:\Users\Public\Desktop"
    Stop-Process parsecd -Force
    }


# Function for installing VB Cable
Function VBCableInstallSetupScheduledTask {
$XML = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Install VB Cable</Description>
    <URI>\Install VB Cable</URI>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).Name)</UserId>
      <Delay>PT2M</Delay>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value)</UserId>
      <LogonType>S4U</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe</Command>
      <Arguments>-file %programdata%\Easy-GPU-P\VBCableInstall.ps1</Arguments>
    </Exec>
  </Actions>
</Task>
"@

    try {
        Get-ScheduledTask -TaskName "Install VB Cable" -ErrorAction Stop | Out-Null
        Unregister-ScheduledTask -TaskName "Install VB Cable" -Confirm:$false
        }
    catch {}
    $action = New-ScheduledTaskAction -Execute 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe' -Argument '-file %programdata%\Easy-GPU-P\VBCableInstall.ps1'
    $trigger =  New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -XML $XML -TaskName "Install VB Cable" | Out-Null
    }

VBCableInstallSetupScheduledTask


# Function for installing ParsecVDA - Always Connected
Function ParsecVDAInstallSetupScheduledTask {
$XML = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Install ParsecVDA</Description>
    <URI>\Install ParsecVDA</URI>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).Name)</UserId>
      <Delay>PT2M</Delay>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value)</UserId>
      <LogonType>S4U</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe</Command>
      <Arguments>-file %programdata%\Easy-GPU-P\ParsecVDAInstall.ps1</Arguments>
    </Exec>
  </Actions>
</Task>
"@

    try {
        Get-ScheduledTask -TaskName "Install ParsecVDA" -ErrorAction Stop | Out-Null
        Unregister-ScheduledTask -TaskName "Install ParsecVDA" -Confirm:$false
    } catch {}
    $action = New-ScheduledTaskAction -Execute 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe' -Argument '-file %programdata%\Easy-GPU-P\ParsecVDAInstall.ps1'
    $trigger =  New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -XML $XML -TaskName "Install ParsecVDA" | Out-Null
    }

ParsecVDAInstallSetupScheduledTask


# Function for disabling One Drive Autostart
Function OneDriveDisableScheduledTask {
    $XML = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Disable OneDrive Autostart</Description>
    <URI>\DisableOneDriveAutostart</URI>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).Name)</UserId>
      <Delay>PT2M</Delay>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>$(([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value)</UserId>
      <LogonType>S4U</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe</Command>
      <Arguments>-file %programdata%\Easy-GPU-P\DisableOneDriveAutostart.ps1</Arguments>
    </Exec>
  </Actions>
</Task>
"@

    try {
        Get-ScheduledTask -TaskName "DisableOneDriveAutostart" -ErrorAction Stop | Out-Null
        Unregister-ScheduledTask -TaskName "DisableOneDriveAutostart" -Confirm:$false
    } catch {}
    $action = New-ScheduledTaskAction -Execute 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe' -Argument '-file %programdata%\Easy-GPU-P\DisableOneDriveAutostart.ps1'
    $trigger =  New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -XML $XML -TaskName "DisableOneDriveAutostart" | Out-Null
    }

OneDriveDisableScheduledTask


Start-ScheduledTask -TaskName "Install VB Cable"
Start-ScheduledTask -TaskName "Install ParsecVDA"
Start-ScheduledTask -TaskName "DisableOneDriveAutostart"


# Set the "Turn off the display" parameter to never
powercfg.exe /change monitor-timeout-ac 0


# Function to remove the logon script entry
Function Remove-LogonScript {
    $scriptPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Logon\0"
    if (Test-Path $scriptPath) {
        Remove-Item $scriptPath -Recurse -Force
    }
}

# Remove the logon script entry to prevent further executions
Remove-LogonScript
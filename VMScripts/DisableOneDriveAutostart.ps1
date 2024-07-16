# Function to disable OneDrive autostart
Function Disable-OneDriveAutostart {
    param (
        [string]$onedrivePath
    )
    # Disable its autostart by setting the value to an empty string
    Set-ItemProperty -Path $onedrivePath -Name "OneDrive" -Value ""
    Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue | Stop-Process -Force
}

# Function to remove the scheduled task
Function Remove-ScheduledTask {
    param (
        [string]$taskName
    )
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Variables
$onedrivePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$taskName = "DisableOneDriveAutostart"
$onedriveInstalled = $false

# Check for OneDrive installation
while (-not $onedriveInstalled) {
    $runKeys = Get-ItemProperty -Path $onedrivePath -ErrorAction SilentlyContinue
    if ($runKeys -and $runKeys.PSObject.Properties.Name -contains "OneDrive") {
        $onedriveInstalled = $true
    } else {
        Start-Sleep -Seconds 5
    }
}

# Disable OneDrive autostart
Disable-OneDriveAutostart -onedrivePath $onedrivePath

# Remove the scheduled task to prevent further executions
Remove-ScheduledTask -taskName $taskName
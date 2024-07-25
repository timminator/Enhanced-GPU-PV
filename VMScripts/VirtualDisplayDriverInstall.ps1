# Function to remove the scheduled task
Function Remove-ScheduledTask {
    param (
        [string]$taskName
    )
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Variables
$taskName = "Install VirtualDisplayDriver"
$downloadUrl = "https://github.com/timminator/Virtual-Display-Driver/releases/download/v1.0.1/Virtual.Display.Driver-v1.0.1-setup-x64.exe"
$downloadPath = "C:\Users\$env:USERNAME\Downloads\Virtual.Display.Driver-v1.0.1-setup-x64.exe"
$scriptFolder = (Get-Item -Path $MyInvocation.MyCommand.Definition).DirectoryName
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$vbScriptPath = "$scriptFolder\SwitchDisplayVDD.vbs"
$iconPath = "$scriptFolder\VirtualDisplayDriver.ico"
$shortcutPath = "$desktopPath\Switch Display to Virtual Display.lnk"

# Download and install ParsecVDA
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $downloadPath)
Start-Process $downloadPath -ArgumentList "/VERYSILENT", "/SUPPRESSMSGBOXES" -Wait

# Create a new shortcut on the user's desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $vbScriptPath
$shortcut.IconLocation = $iconPath
$shortcut.Save()

# Remove the scheduled task to prevent further executions
Remove-ScheduledTask -taskName $taskName
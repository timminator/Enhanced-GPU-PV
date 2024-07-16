# Function to remove the scheduled task
Function Remove-ScheduledTask {
    param (
        [string]$taskName
    )
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Variables
$taskName = "Install ParsecVDA"
$downloadUrl = "https://github.com/timminator/ParsecVDA-Always-Connected/releases/download/v1.4.1/ParsecVDA.-.Always.Connected-v1.4.1-setup-x64.exe"
$downloadPath = "C:\Users\$env:USERNAME\Downloads\ParsecVDA.-.Always.Connected-v1.4.1-setup-x64.exe"
$scriptFolder = (Get-Item -Path $MyInvocation.MyCommand.Definition).DirectoryName
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$vbScriptPath = "$scriptFolder\SwitchDisplay.vbs"
$iconPath = "$scriptFolder\ParsecVDA.ico"
$shortcutPath = "$desktopPath\Switch Display to ParsecVDA.lnk"

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
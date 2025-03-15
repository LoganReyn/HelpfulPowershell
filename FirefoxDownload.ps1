# function to download stuff 
# 

function Install-Software {
<#
    .SYNOPSIS
    Installs software by downloading it from a specified URL and running it with optional arguments.

    .DESCRIPTION
    This function downloads an installer from the provided URL, saves it to the TEMP folder, and executes it with the provided silent installation arguments. 
    After the installation completes, it removes the installer from the TEMP folder.

    .PARAMETER DownloadUrl
    The URL of the installer to download.

    .PARAMETER OutName
    The name to save the installer as when downloaded. It is recommended to use an appropriate name for the software.

    .PARAMETER InstallArgs
    Optional. The silent install argument to be passed to the installer. Defaults to "/silent".
    Some installers may use different arguments, such as "/quiet" or "/verysilent".

    .EXAMPLE
    Install-Software -DownloadUrl "https://example.com/installer.exe" -OutName "example-installer"

    .EXAMPLE
    Install-Software -DownloadUrl "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US" -OutName "firefox-latest" -InstallArgs "/quiet"

    .NOTES
    - Ensure you have appropriate permissions to install software on the machine.
    - Some installers may require UAC elevation for installation.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string]$DownloadUrl,

        [Parameter(Mandatory=$True)]
        [string]$OutName,

        [Parameter(Mandatory=$False)]
        [string]$InstallArgs = "/silent" # not sure if every installer uses 'silent'
    )

    # storing the download in the TEMP folder
    $criticalPath = "$env:TEMP\$OutName.exe"

    try {
        Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$criticalPath" -ErrorAction Stop
        # Using "silent" in arg path should bypass UAC but still run as admin
        Start-Process -FilePath $criticalPath -ArgumentList "$installArgs" -Wait -NoNewWindow
        # Cleaning up TEMP after the installation is complete
        Remove-Item -Path $criticalPath
        Write-Host "Application Installed Successfully -> $OutName"
    }
    catch {
        Write-Host "ERROR: [$_]"
    }
}


$firefox = "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US"

Install-Software -DownloadUrl $firefox -OutName "firefox-latest"
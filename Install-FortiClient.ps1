<#
    .NOTES
    Version:        1.0
    Author:         Dylan Addison
    Creation Date:  16/03/23

    .SYNOPSIS
    Downloads and install FortiClient and/or VPN tunnels from a public URL.

    .DESCRIPTION
    Downloads and install FortiClient and/or VPN tunnels from a public URL. It can also be used to export existing VPN tunnels.

    .PARAMETER FortiClientUrl
    The URL to the FortiClient VPN Installer.

    .PARAMETER FortiClientConfigUrl
    The URL to the registry file containing the VPN tunnels.

    .PARAMETER ExportConfigs
    A switch to export the existing VPN tunnels. Other parameters are ignored when this is used.

    .EXAMPLE
    .\Install-FortiClient.ps1 -FortiClientUrl "apublicsite.com/forticlient.exe" -FortiClientConfigUrl "apublicsite.com/forticlientconfig.reg"
#>
param (
    [Parameter(Mandatory=$false)][string]$FortiClientUrl,
    [Parameter(Mandatory=$false)][string]$FortiClientConfigUrl,
    [Parameter(Mandatory=$false)][switch]$ExportConfigs
)

$techPath = "C:\Tech"
$fortiClientBin = "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"
$fortiClientInstaller = "C:\Tech\FortiClientInstaller.exe"
$fortiClientConfig = "C:\Tech\FortiClientConfig.reg"
$registryEditor = "C:\Windows\System32\reg.exe"
$fortiClientTunnels = "HKEY_LOCAL_MACHINE\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels"

function Import-VpnConfig() {
    Write-Host "Downloading FortiClient VPN Configuration..." -ForegroundColor Cyan -NoNewline
    Invoke-WebRequest $FortiClientConfigUrl -OutFile $fortiClientConfig
    Write-Host "Done`n" -ForegroundColor Green

    Write-Host "Importing FortiClient VPN Configuration..." -ForegroundColor Cyan -NoNewline
    Start-Process -FilePath $registryEditor -ArgumentList "import", $fortiClientConfig
    Write-Host "Done`n" -ForegroundColor Green
}

function Install-VpnClient() {
    if (Test-FortiClientInstallation) {
        return
    }

    Write-Host "Downloading FortiClient VPN..." -ForegroundColor Cyan -NoNewline
    Invoke-WebRequest $FortiClientUrl -OutFile $fortiClientInstaller
    Write-Host "Done`n" -ForegroundColor Green

    Write-Host "Installing FortiClient VPN..." -ForegroundColor Cyan -NoNewline
    Start-Process -FilePath $fortiClientInstaller -ArgumentList "/quiet", "/norestart" -Wait
    Write-Host "Done`n" -ForegroundColor Green

}

function Set-TechFolder() {
    if (Test-Path $techPath) {
        Write-Host "C:\Tech already exists" -ForegroundColor Green 
    } else {
        Write-Host "Creating C:\Tech folder..." -ForegroundColor Cyan -NoNewline
        New-Item -Path "C:\Tech" -ItemType Directory -ErrorAction SilentlyContinue -InformationAction SilentlyContinue
        Write-Host "Done`n" -ForegroundColor Green
    }
}

function Test-FortiClientInstallation() {
    if (Test-Path $fortiClientBin -PathType Leaf) {
        Write-Host "FortiClient is already installed" -ForegroundColor Cyan
        return $true
    } else {
        return $false
    }
}

function Export-FortiClientConfigs() {
    Write-Host "Exporting FortiClient VPN Configuration..." -ForegroundColor Cyan -NoNewline
    Start-Process -FilePath $registryEditor -ArgumentList "export", $fortiClientTunnels, $fortiClientConfig, "/y"
    Write-Host "Done`n" -ForegroundColor Green
}

Set-TechFolder

if ($ExportConfigs) {
    Export-FortiClientConfigs
    exit 0
}

if ($FortiClientUrl) {
    Install-VpnClient
}

if ($FortiClientConfigUrl) {
    Import-VpnConfig
}


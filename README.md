##  Overview
This script allows for easy deployment of the FortiClient VPN application as well configuring VPN tunnels via the CLI. It works by providing a URL to the FortiClient installer and/or any tunnels you want to import. It also has the option to export existing tunnels from a device to be deployed elsewhere.

**The script must be run as administrator and requires an internet connection for the download to work.**

###  Getting an Installer
The FortiClient VPN installer provided by FortiGate is an online installer. It will automatically download the latest version of the actual installer. It cannot be used with this script as it has no silent switches. To get the proper installer, download the online installer and execute it. It will download the main installer in the background. Wait for the **FortiClient VPN Setup Wizard** to appear and then navigate to the **%LocalAppData%\Temp** directory. Copy the **FortiClientVPN.exe** to another location. You can then exit the **FortiClient VPN Setup Wizard**.

###  Parameters
This script has 3 parameters:

-  `FortiClientUrl`
This is the URL to the FortiClientVPN Installer. This parameter is optional and can be used by itself or not at all. If it is not provided, no installation of FortiClient VPN will be attempted. If FortiClient VPN is already installed, the script will simply skip installation of FortiClient VPN.

-  `FortiClientConfigUrl`
This is the URL to the VPN tunnels you want to import. You can configure VPN tunnels in FortiClient VPN and then export them with this script using the `ExportConfigs` switch. This parameter is optional and can be used by itself or not at all. If it is not provided, no tunnels will be added.

-  `ExportConfigs`
This will export any FortiClient VPN tunnels to a file called `C:\Tech\FortiClientConfig.reg`. If this switch is specified all other parameters are ignored.
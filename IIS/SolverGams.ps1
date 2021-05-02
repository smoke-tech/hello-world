#####################################################################################################################

# This script installs IIS and the features required to

# run Pensionsplan.

# Install the Website and apppool

#

# * Make sure you run this script from a Powershel Admin Prompt!

# * Make sure Powershell Execution Policy is bypassed to run these scripts:

# * YOU MAY HAVE TO RUN THIS COMMAND PRIOR TO RUNNING THIS SCRIPT!

# To list all Windows Features: dism /online /Get-Features

# Get-WindowsOptionalFeature -Online

# LIST All IIS FEATURES:

# Get-WindowsOptionalFeature -Online | where FeatureName -like 'IIS-*'

 

### Modules #########################################################################################################

Clear-Host

# WebAdministration

Import-Module WebAdministration

# Unrestricted Excution

# Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#####################################################################################################################

 

### Variables #######################################################################################################

$iisAppPoolName = "SolverGamsAppPool"

$iisAppPoolDotNetVersion = "v4.0"

$iisAppName = "SolverGams"

$iisHostHeader = "solvergamsprod.sampension.net"

$iisDirectoryPath = "E:\inetpub\wwwroot\SolverGams"

 

$strUNCpath = "\\sampension.net\it\Drift\Driftsdokumentation\Pensionsplan"  #Source directory Business software

$StrLocalPath = "c:\temp"  # Destination directory

#####################################################################################################################

 

$error.clear()

$ErrorActionPreference="stop"

try{

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer

Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures

Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security

Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering

Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent

Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument

Enable-WindowsOptionalFeature -Online -FeatureName IIS-DirectoryBrowsing

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment

Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45

Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASP

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ClientCertificateMappingAuthentication

Enable-WindowsOptionalFeature -Online -FeatureName IIS-IISCertificateMappingAuthentication

Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole

#.Net 4.6

Enable-WindowsOptionalFeature -Online -FeatureName WCF-Services45

Enable-WindowsOptionalFeature -Online -FeatureName WAS-WindowsActivationService

Enable-WindowsOptionalFeature -Online -FeatureName WAS-ProcessModel

Enable-WindowsOptionalFeature -Online -FeatureName WAS-ConfigurationAPI

Enable-WindowsOptionalFeature -Online -FeatureName WCF-HTTP-Activation45

#.Net 3.5

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment

Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility

Enable-WindowsOptionalFeature -Online -FeatureName WAS-NetFxEnvironment

}catch{throw $error}

 

 

#Create directory

if (!(Test-path $StrLocalPath))

{

New-Item -ItemType "directory" -Path "$StrLocalPath"

}

 

#Copy source files to C:\Temp

Copy-Item -Path "$strUNCpath\*" -Destination "$StrLocalPath" -Recurse -force

 

 

#Create IIS directory

If (!(test-path $iisDirectoryPath))

{

    New-Item -ItemType "directory" -Path "$iisDirectoryPath"

}

 

####NTFS permissions on e:\inetpub\wwwroot\* scripting does not work yet....

# Install PowerShell module

# Install-Module -Name NTFSSecurity # https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85

 

#Remove NTFS inheritance webserver folder

#$acl = Get-ACL -Path $iisDirectoryPath

#$acl.SetAccessRuleProtection($True, $True)

#Set-Acl -Path $iisDirectoryPath -AclObject $acl

 

##Remove users permissions...

#get-item $iisDirectoryPath | Get-NTFSAccess -Account 'BUILTIN\Users' | Remove-NTFSAccess

 

####NTFS permissions on e:\inetpub\wwwroot\* scripting does not work yet....

 

#navigate to the app pools root

cd IIS:\AppPools\

 

#check if the app pool exists

if (!(Test-Path $iisAppPoolName -pathType container))

{

    #create the app pool

    New-WebAppPool -Name $iisAppPoolName -Force

    Write-Host "$iisAppPoolName  Created"

}

 

#navigate to the sites root

cd IIS:\Sites\

 

#Remove Default Website

If ((test-path "Default Web Site"))

{   

    Remove-WebSite -Name "Default Web Site"

}

 

#check if the site exists

if (!(Test-Path $iisAppName -pathType container))

{ 

   #Create the Website

   New-Website -Name $iisAppName -Port 80 -HostHeader "$iisHostHeader" -ApplicationPool "$iisAppPoolName" -PhysicalPath "$iisDirectoryPath" -Force  

   Write-Host "$iisAppName  Created" 

}

 

#navigate to system root

cd C:\

 

 

#Copy source files to \\wwwroot\SolverGams\*

Copy-Item -Path "$StrLocalPath\SolverGams\*" -Destination "$iisDirectoryPath" -Recurse -force

 

 

Write-host "Prereqs and IIS setup has finished...Continue installation from Gams Installationsvejledning (keylane).pdf

3. Installering af GAMS Software

4.9 web.config adjustments

5. Tjek skriverettigheder

6. Registrering af Solvergams som source for evnents

7. Opdater endoint address i pensionsplan

....."
#$servers = @("SAS00572","SAS00721","SAS00781","SAS00782","SAS00783","SAS00784","SAS00791","SAS00792","SPSPVBIGW-APP101","SPSVCRM-APP102","SPSVIFR-WEB101","SPSVNAV-APP101","SPSVTM-WEB101","SPSVWF-WEB102","SWB00542","SWB00771","TAPFON122","TAPFON124","SPSVFON-APP201")

$servers = Get-Content -Path "c:\temp\servers.csv" 
$servers

$destpath = "C:\Install\AppDynClients"
$destpath

foreach ($server in $servers)

{

  write-host $server

  $sourcepath = "\\" + $server + "\c$\ProgramData\AppDynamics\DotNetAgent\Config"

  $sourcepath
}
 
foreach ($server in $servers)

{

  write-host $server

  if(!(Test-Path -Path $destpath\$server))

   {

   New-Item -ItemType directory -Path $destpath\$server

   Write-Host "Folder path has been created successfully at: "   $destpath\$server

   } 
   else{

    Write-Host "The given folder path $destpath\$server already exists";
    
    }
 }

 foreach ($server in $servers)

 {
 
   write-host "files copied from:" $server
 
   Copy-Item $sourcepath\*.* $destpath\$server -Force
 }




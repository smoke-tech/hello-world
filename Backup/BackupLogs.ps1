$servers = @("SPSVAPPD-APM101","SPSVAPPD-APM102")

$Controller  = "SPSVAPPD-APM101"

$EventServer = "SPSVAPPD-APM102"

 

$path = "C:\Transfer\logs"

 

$SourcePathController = "\\SPSVAPPD-APM101\e$\AppDynamics\Platform\product\controller\logs"

$SourcePathEventServer = "\\SPSVAPPD-APM102\e$\AppDynamics\Platform\product\events-service\logs"

 

$datecurrent = get-date -Format "yyyyMMdd-hhmmss"

 

$servers = @("SPSVAPPD-APM101","SPSVAPPD-APM102")

$datecurrent = get-date -Format "yyyyMMdd-hhmmss"

$path = "C:\Transfer\logs"

 

#Create directory

 

foreach ($server in $servers)

{

  if(!(Test-Path -Path $path\$server\$datecurrent))

   {

    #write-host $server

    New-Item -ItemType "directory" -Name $datecurrent -Path $path\$server

    Write-Host "Folder path has been created successfully at:    $path\$server\$datecurrent"

    }

    else

        {

        Write-Host "The given folder path $destpath\$server already exists";

        }

}

 

 

#copy logs files

try

{

    Copy-Item $SourcePathController\*.* $path\$Controller\$datecurrent -Force -Exclude 'server.log.lck' -ErrorAction stop

    Write-Host "Logs has been successfully copied to:    $path\$Controller\$datecurrent"

}

catch

{

    Write-Host "Copy logs $SourcePathController failed.."   

}

 

try

{

    Copy-Item $SourcePathEventServer\*.* $path\$EventServer\$datecurrent -Force

    Write-Host "Logs has been successfully copied to:    $path\$EventServer\$datecurrent"

}

catch

{

    Write-Host "Copy logs $SourcePathEventServer failed.."   

}

 

#Archive folders

$SourcePathController

 

Compress-Archive -Path $path\$Controller -DestinationPath C:\transfer\Archives\$datecurrent$Controller.zip

Compress-Archive -Path $path\$EventServer -DestinationPath C:\transfer\Archives\$datecurrent$EventServer.zip

 

 

 

Move-Item C:\transfer\Archives\*.* \\sampension.net\public\Public2\sbs\AppDynamics\

 

#Cleanup

Remove-Item C:\transfer\logs\* -Recurse
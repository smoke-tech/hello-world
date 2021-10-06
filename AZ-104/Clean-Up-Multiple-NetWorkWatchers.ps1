Get-AzSubscription 
#Clean up multiple regions NetWorkWatchers
Get-AZNetworkWatcher | Select Name,Location,ProvisioningState
Get-AZNetworkWatcher | Remove-AZNetworkWatcher


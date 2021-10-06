Set-ExecutionPolicy RemoteSigned
Install-Module -Name Az -AllowClobber -SkipPublisherCheck
Update-Module -Name Az

#Set-ExecutionPolicy RemoteSigned
Get-ExecutionPolicy
Import-Module Az
Connect-AzAccount
Get-AzSubscription
Select-AzSubscription -subscriptionid '139096f2-8428-4f33-82e7-e0e64c69eb43'

Get-AzResourceGroup | Format-Table


$tags = @{"Department"="myself"; "Status"="Normal"}
$resource = Get-AzResource -Name SBS-TEST-VAULT01 -ResourceGroup sbs-test-rg01
New-AzTag -ResourceId $resource.id -Tag $tags
New-AzVm -ResourceGroupName sbs-test-rg01 -Name "testvm-weu-01" -Credential (Get-Credential) -Location "West Europe" -Image UbuntuLTS -OpenPorts 22

$vm = (Get-AzVM -Name "testvm-weu-01" -ResourceGroupName sbs-test-rg01)

$vm

$vm.HardwareProfile

$vm.StorageProfile.OsDisk

$vm | Get-AzPublicIpAddress

Stop-AzVM -Name $vm.Name -ResourceGroup $vm.ResourceGroupName
Remove-AzVM -Name $vm.Name -ResourceGroup $vm.ResourceGroupName

Get-AzResource -ResourceGroupName $vm.ResourceGroupName | ft
$vm | Remove-AzNetworkInterface –Force
Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $vm.StorageProfile.OSDisk.Name | Remove-AzDisk -Force
Get-AzVirtualNetwork -ResourceGroup $vm.ResourceGroupName | Remove-AzVirtualNetwork -Force
Get-AzNetworkSecurityGroup -ResourceGroup $vm.ResourceGroupName | Remove-AzNetworkSecurityGroup -Force
Get-AzPublicIpAddress -ResourceGroup $vm.ResourceGroupName | Remove-AzPublicIpAddress -Force
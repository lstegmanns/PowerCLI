<#
Created by Lucas Stegmanns lstegmanns@vmware.com , use at own risk.


23.06.2021: Creates a report over PCI Device IDs for all NICs and HBAs in the connected vCenter.
            Including Driver Versions. 


#>





##clear variables
$hosts = $null
$esxcli = $null
$output = $null
$list = $null
$hosti = $null
$filenameFormat = $null
$pci = $null
$viServer = vc1.vmlab.com
#creates empty arry for csv export
$list=@()



Connect-VIServer -Server $viServer
$hosts = Get-VMHost





foreach( $hosti in $hosts){
    $hosti.Name
    $esxcli = Get-EsxCLI -VMHost $hosti -V2
    $output=$esxcli.hardware.pci.list.Invoke() | where { ($_.VMkernelName -like 'vmnic*') -or ( $_.VMkernelName -like 'vmhba*') }
    $vibs = $esxcli.software.vib.list.Invoke()
    foreach($device in $output){
            Add-Member -InputObject $device -MemberType NoteProperty -Name "ESXiHost" -Value $hosti.Name -PassThru |Out-Null
            Add-Member -InputObject $device -MemberType NoteProperty -Name "Cluster" -Value $hosti.Parent.name -PassThru |Out-Null
            Add-Member -InputObject $device -MemberType NoteProperty -Name "Datacenter" -Value $hosti.Parent.ParentFolder.Parent -PassThru |Out-Null
            Add-Member -InputObject $device -MemberType NoteProperty -Name "Driver" -Value $($vibs | where { ($_.Name -like $device.ModuleName ) }).Version -PassThru |Out-Null
                        }
    $list += $output
}

$filenameFormat = (Get-Date -Format "yyyyMMdd_HHmmss") + "PCIDevices_AllHosts.csv"
$list | Export-Csv -Path $filenameFormat  -NoTypeInformation
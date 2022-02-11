<#
Created by Lucas Stegmanns lstegmanns@vmware.com , use at own risk.


11.02.2022: Use-Case1: Add hosts to vCenter with expired license
            Use-Case2: Change license from free to paied and add it to a vCenter

Required CSV File-Format: 
     FQDN,user,pw
     esx.corp.local,root,Password!

#>


$csvFilePath = "C:\Users\<User>\Desktop\hosts.csv"
$licenseKey = "00000-00000-00000-00000-00000"
$vcServer = "vcsa-01a-corp.local"
$vcUser = "administrator@corp.local"
$vcPassword = "<Password>"
$targetLocation = "RegionA01"




# Import of a Host list
$hosts = Import-csv -Path $csvFilePath -Delimiter ','

##Connect to each individual host, set license, disconnect again

foreach($hosti in $hosts){
        Connect-VIServer -Server $hosti.Name -User $hosti.user -Password $hosti.pw
        $hostn = Get-VMHost
        Set-VMHost -VMHost $hostn -LicenseKey $licenseKey
        Disconnect-VIServer * -force -Confirm:$false
        }

## Connect to vCenter, choose location, add hosts to vCenter, discconect again.
Connect-VIServer -Server $vcServer -user $vcUser -Password "VMware1!"


foreach ($hosti in $hosts){
        Add-VMHost $hosti.Hosti -Location $targetLocation -User $hosti.user -Password $hosti.pw -Force
        }


Disconnect-VIServer * -force -Confirm:$false

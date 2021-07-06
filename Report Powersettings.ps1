<#
Created by Lucas Stegmanns lstegmanns@vmware.com , use at own risk.


06.07.2021: Reports all Powersettings of ESXi Hosts into a CSV 


#>

$hosts = $null
$hosti = $null
$clusterName = "Cluster1"
$viServer = "vc1.vmlab.com"
$list = $null

Connect-VIServer -Server $viServer
$hosts = Get-VMHost
#$hosts = Get-Cluster -Name $clusterName |Get-VMHost


#query all powersettings
$list = @()
$list = $hosts | Select Name,
@{ N="CurrentPolicy"; E={$_.ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName}},
@{ N="CurrentPolicyKey"; E={$_.ExtensionData.config.PowerSystemInfo.CurrentPolicy.Key}},
@{ N="AvailablePolicies"; E={$_.ExtensionData.config.PowerSystemCapability.AvailablePolicy.ShortName}},
@{ N="CurrentHWPolicy"; E={$_.ExtensionData.Hardware.CpuPowerManagementInfo.CurrentPolicy}},
@{ N="HWSupport"; E={$_.ExtensionData.Hardware.CpuPowerManagementInfo.HardwareSupport}}


$list | Export-CSV -Path ./Powersettings.csv -NoTypeInformation
<#
Created by Lucas Stegmanns lstegmanns@vmware.com , use at own risk.


06.07.2021: Disables Timeout Values for ESXI Shell, DCUI and disables SSH-Enabled Warning
            For production environments you may set the limits based on your Security requirements like 3600 (60 Minutes) 
            UserVars.SuppressShellWarning should be set to 0 (Default) 


#>

$hosts = $null
$hosti = $null
$clusterName = "Cluster1"
$viServer = "vc1.vmlab.com"

##conect to vCenter and Get the Host list
Connect-VIServer -Server $viServer
$hosts = Get-VMHost
#$hosts = Get-Cluster -Name $clusterName |Get-VMHost


# set the config parameters
 foreach ($hosti in $hosts){
    $hosti.Name
    Get-AdvancedSetting -Entity $hosti -Name UserVars.ESXiShellInteractiveTimeOut | Set-AdvancedSetting -Value 0 -Confirm:$false
    Get-AdvancedSetting -Entity $hosti -Name UserVars.DcuiTimeOut | Set-AdvancedSetting -Value 0 -Confirm:$false
    Get-AdvancedSetting -Entity $hosti -Name UserVars.ESXiShellTimeOut | Set-AdvancedSetting -Value 0 -Confirm:$false
    Get-AdvancedSetting -Entity $hosti -Name UserVars.SuppressShellWarning | Set-AdvancedSetting -Value 1 -Confirm:$false
    }
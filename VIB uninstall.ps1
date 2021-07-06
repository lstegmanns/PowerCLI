<#
Created by Lucas Stegmanns lstegmanns@vmware.com , use at own risk.


01.07.2021: Manually uninstalls a VIB on all Hosts where the VIB name is $vibName


#>

##clear variables
$hosts = $null
$esxcli = $null
$args1 = $null
$hosti = $null
$clusterName = "Cluster1"
$viServer = "vc1.vmlab.com"
$vibName = 'vmware-storcli-007.0709.0000.0000'


##conect to vCenter and Get the Host list
Connect-VIServer -Server $viServer
$hosts = Get-VMHost
#$hosts = Get-Cluster -Name $clusterName |Get-VMHost


##Create esxcli command and trigger VIB uninstall
 foreach ($hosti in $hosts){
    $hosti.Name
    $esxcli = Get-EsxCLI -VMHost $hosti -V2
    $args1=$esxcli.software.vib.remove.CreateArgs()
    $args1.vibname = $vibName
    $esxcli.software.vib.remove.invoke($args1)
    }
 

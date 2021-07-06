<#
Created by Lucas Stegmanns lstegmanns@vmware.com , use at own risk.


01.07.2021: Manually installs a VIB on all Hosts where the VIB file is located under $vibLocation


#>

##clear variables
$hosts = $null
$esxcli = $null
$args1 = $null
$hosti = $null
$clusterName = "Cluster1"
$viServer = "vc1.vmlab.com"
$vibLocation = '/var/core/FTS_LSISASMegaRAIDcontrollerconfigurationutility_7709_1211093.VIB'


##conect to vCenter and Get the Host list
Connect-VIServer -Server $viServer
$hosts = Get-VMHost
#$hosts = Get-Cluster -Name $clusterName |Get-VMHost


##Create esxcli command and trigger VIB install
 foreach ($hosti in $hosts){
    $hosti.Name
    $esxcli = Get-EsxCLI -VMHost $hosti -V2
    $args1=$esxcli.software.vib.install.CreateArgs()
    $args1.viburl = $vibLocation
    $esxcli.software.vib.install.invoke($args1)
    }
 

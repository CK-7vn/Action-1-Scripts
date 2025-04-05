<#
Crated by: CrocodileWerewolf (Reddit)
This data source returns all active Windows Firewall rules, including name, profile, direction, action, program, service, protocol, ports, IP filters, and rule source
#>
# Works only for Windows Pro or above and for Windows Server
$Result = New-Object System.Collections.ArrayList

$Int = 0 

# Get current enabled and active rules, by having "PrimaryStatus Ok" only active rules will be capture. This will exclude local rules when local rule merge is off.
$Rules = Get-NetFirewallRule -Enabled True -PrimaryStatus OK -PolicyStore ActiveStore

$Now = Get-Date 

foreach ($Rule in $Rules) {
 
    $Record = "" | Select-Object 'Display Name', 'Description', 'Enabled', 'Profile', 'Direction', 'Action', 'Program', 'Service', 'Local Address', 'Remote Address', 'Protocol', 'Local Port', 'Remote Port', 'Source', 'As At', A1_Key 

    $AddressFilter = Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $Rule -PolicyStore ActiveStore 
    $PortFilter = Get-NetFirewallPortFilter -AssociatedNetFirewallRule $Rule -PolicyStore ActiveStore
    $AppFilter = Get-NetFirewallApplicationFilter -AssociatedNetFirewallRule $Rule -PolicyStore ActiveStore
    $ServiceFilter = Get-NetFirewallServiceFilter -AssociatedNetFirewallRule $Rule -PolicyStore ActiveStore 
    $Record.'Display Name' = $Rule.DisplayName
    $Record.'Description' = $Rule.Description
    $Record.'Enabled' = $Rule.Enabled 
    $Record.'Profile' = $Rule.Profile 
    $Record.'Direction' = $Rule.Direction 
    $Record.'Action' = $Rule.Action 
    $Record.'Program' = $AppFilter.Program 
    $Record.'Service' = $ServiceFilter.Service
    if ($AddressFilter.LocalAddress) { 
        $Record.'Local Address' = $AddressFilter.LocalAddress 
    } else { 
        $Record.'Local Address' = 'Any' 
    } 
    if ($AddressFilter.RemoteAddress) { 
        $Record.'Remote Address' = $AddressFilter.RemoteAddress 
    } else { 
        $Record.'Remote Address' = 'Any'
    } 
    $Record.'Protocol' = $PortFilter.Protocol 
    $Record.'Local Port' = $PortFilter.LocalPort 
    $Record.'Remote Port' = $PortFilter.RemotePort 
    $Record.'Source' = $Rule.PolicyStoreSourceType 
    $Record.'As At' = $Now 
    $Record.A1_Key = $Int 
    $Result.Add($Record) | Out-Null 
    $Int = ($Int + 1)
} 

Write-Output $Result

<#
Created by: tigergruppy126 (Reddit)
This data source lists all the NICs on a system, if it's using DHCP (if so, what's the DHCP server), the IPv4 address, DNS servers, and public IP for each NIC.
#>
Function Get-NetworkAdapterInfo {
	$results = @()
	
	# Get all active physical network adapters
	$activeAdapters = Get-NetAdapter -Physical | Where-Object { $_.Status -eq 'Up' }
	
	foreach ($adapter in $activeAdapters) {
		try {
			# Retrieve IP configuration for the adapter (suppress errors)
			$ipConfig = Get-NetIPConfiguration -InterfaceIndex $adapter.IfIndex -ErrorAction Stop 2>$null
		} catch {
			continue
		}
		
		if (-not $ipConfig) { continue }
		
		# Use CIM to retrieve DHCP details using the adapter's InterfaceIndex
		$cimConfig = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration `
			-Filter "InterfaceIndex = $($adapter.IfIndex)" -ErrorAction SilentlyContinue
		
		if ($cimConfig) {
			$dhcpEnabled = $cimConfig.DHCPEnabled -eq $true
			$dhcpServer = if ($dhcpEnabled -and $cimConfig.DHCPServer) {
				if ($cimConfig.DHCPServer -is [array]) {
					$cimConfig.DHCPServer -join ', '
				} else {
					$cimConfig.DHCPServer
				}
			} else { 'N/A' }
		} else {
			$dhcpEnabled = $false
			$dhcpServer = 'N/A'
		}
		
		# Process each IPv4 address (if available) on the adapter
		if ($ipConfig.IPv4Address) {
			foreach ($ipv4 in $ipConfig.IPv4Address) {
				$results += [PSCustomObject]@{
					AdapterName    = $adapter.Name
					NICDescription = $adapter.InterfaceDescription
					IPv4Address    = $ipv4.IPAddress
					DHCPEnabled    = $dhcpEnabled
					DHCPServer     = $dhcpServer
					DNSServers     = ($ipConfig.DnsServer.ServerAddresses -join ', ')
				}
			}
		}
	}
	
	return $results
}

# Retrieve the network adapter info via our function
$Objects = Get-NetworkAdapterInfo

# Build the final Action1 output collection using an ArrayList
$result = New-Object System.Collections.ArrayList
$numerator = 0

$Objects | ForEach-Object {
	$currentOutput = '' | Select-Object AdapterName, NICDescription, DHCPEnabled, DHCPServer, DNSServers, IPv4Address, A1_Key
	$currentOutput.AdapterName = $_.AdapterName
	$currentOutput.NICDescription = $_.NICDescription
	$currentOutput.DHCPEnabled = $_.DHCPEnabled
	$currentOutput.DHCPServer = $_.DHCPServer
	$currentOutput.DNSServers = $_.DNSServers
	$currentOutput.IPv4Address = $_.IPv4Address
	$currentOutput.A1_Key = $numerator

	$result.Add($currentOutput) | Out-Null
	$numerator ++
}
	
$result


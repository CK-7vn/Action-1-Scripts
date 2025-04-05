<#
Created by: Acceptable_Cell_4096 (Reddit)

#>
# Get the computer name

$computerName = $env:COMPUTERNAME

# Get the operating system information

$os = Get-WmiObject -Class Win32_OperatingSystem

$osName = $os.Caption

$osVersion = $os.Version

$osInstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime($os.InstallDate).ToString("yyyy-MM-dd")

# Get the BIOS release date

$bios = Get-WmiObject -Class Win32_BIOS

$biosReleaseDate = [System.Management.ManagementDateTimeConverter]::ToDateTime($bios.ReleaseDate).ToString("yyyy-MM-dd")

# Create an object with the collected information

$output = [PSCustomObject]@{

OSName = $osName

OSVersion = $osVersion

OSInstallDate = $osInstallDate

BIOSDate = $biosReleaseDate

A1_Key = $computerName

}

Write-Output $output

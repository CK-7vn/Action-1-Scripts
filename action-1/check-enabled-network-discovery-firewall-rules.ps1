<#
Created By: synkus (Reddit)
#>
Get-NetFirewallRule -Group "@FirewallAPI.dll,-32752" -Enabled True -ErrorAction SilentlyContinue | ForEach-Object {
    $output = [PSCustomObject]@{
        'DisplayName' = $_.DisplayName
        'Enabled'     = $_.Enabled
        'Profile'     = $_.Profile
        'A1_Key'      = $_.Name
    }
    Write-Output $output
}

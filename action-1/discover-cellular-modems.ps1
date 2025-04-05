<# 
Created by: jwalker55 (Reddit)
#>
$obj = Get-WmiObject -Namespace "root\cimv2\mdm\dmmap" -ClassName MDM_DeviceStatus_CellularIdentities01_01
 
$result = New-Object System.Collections.ArrayList;
$numerator = 0;
 
$obj | ForEach-Object {
    $currentOutput = "" | Select-Object Carrier, SIM, IMEI, PhoneNumber, A1_Key
    $currentOutput.Carrier = $_.CommercializationOperator
    $currentOutput.SIM = $_.ICCID
    $currentOutput.IMEI = $_.InstanceID
    $currentOutput.PhoneNumber = $_.PhoneNumber
    $currentOutput.A1_Key = [string]$numerator + ':' + [string]$_.PSComputerName;
    $numerator++
 
    $result.Add($currentOutput) | Out-Null;
}
 
$result;

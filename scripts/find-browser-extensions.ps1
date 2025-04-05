<#
Created by: vaano (paste bin)
Scans all computers/servers for discovered Chrome/Edge extensions.

#>

$chromeaddon = " - Chrome Web Store"
$edgeaddon = " - Microsoft Edge Addons"
$users = gci c:\users\
foreach ($user in $users){
    $exts = gci "$($user.FullName)\AppData\Local\Microsoft\Edge\User Data\Default\Extensions" -Exclude Temp -ErrorAction SilentlyContinue
    foreach ($ext in $exts)
    {
        $x = Invoke-WebRequest -UseBasicParsing -Uri "https://microsoftedge.microsoft.com/addons/detail/$($ext.Name)"
        $startindex = $x.Content.IndexOf("<title>")
        $stopindex = $x.Content.IndexOf("</title>")
        if ($x.Content.Substring($startindex+7,$stopindex-$startindex-7) -like "Microsoft Edge Addons")
        {
            $x = Invoke-WebRequest -UseBasicParsing -Uri "https://chromewebstore.google.com/detail/$($ext.Name)"
            $startindex = $x.Content.IndexOf("<title>")
            $stopindex = $x.Content.IndexOf("</title>")
        }
        if($x.Content.Substring($startindex+7,$stopindex-$startindex-7) -like "*$edgeaddon*"){
            $output = [PSCustomObject]@{
                'Username' = $user.Name
                'Extension' = $ext.Name 
                'Browser' = "Edge"
                #'Name' = $x.Content.Substring($startindex+7,$stopindex-$startindex-7)
                'Name' = $x.Content.Substring($startindex+7,$x.Content.IndexOf($edgeaddon) - $startindex - 7)
                'Store' = "Microsoft Edge Addons"
                'A1_Key' = $user.Name + $ext.Name
                'URL' = "https://microsoftedge.microsoft.com/addons/detail/$($ext.Name)"
            }
        }
        elseif($x.Content.Substring($startindex+7,$stopindex-$startindex-7) -like "*$chromeaddon*"){
            $output = [PSCustomObject]@{
                'Username' = $user.Name
                'Extension' = $ext.Name 
                'Browser' = "Edge"
                #'Name' = $x.Content.Substring($startindex+7,$stopindex-$startindex-7)
                'Name' = $x.Content.Substring($startindex+7,$x.Content.IndexOf($chromeaddon) - $startindex - 7)
                'Store' = "Chrome Web Store"
                'URL' = "https://chromewebstore.google.com/detail/$($ext.Name)"
                'A1_Key' = $user.Name + $ext.Name
            }
        }
        else{
            $output = [PSCustomObject]@{
                'Username' = $user.Name
                'Extension' = $ext.Name 
                'Browser' = "Edge"
                'Name' = $x.Content.Substring($startindex+7,$stopindex-$startindex-7)
                'Store' = ""
                'URL' = ""
                'A1_Key' = $user.Name + $ext.Name
            }
        }
 
        # pipeline the output object for processing
        Write-Output $output
    }
    $exts = gci "$($user.FullName)\AppData\Local\Google\Chrome\User Data\Default\Extensions" -Exclude Temp -ErrorAction SilentlyContinue
    foreach ($ext in $exts)
    {
        $x = Invoke-WebRequest -UseBasicParsing -Uri "https://chromewebstore.google.com/detail/$($ext.Name)"
        $startindex = $x.Content.IndexOf("<title>")
        $stopindex = $x.Content.IndexOf("</title>")
        if ($x.Content.Substring($startindex+7,$stopindex-$startindex-7) -like "Chrome Web Store")
        {
            $x = Invoke-WebRequest -UseBasicParsing -Uri "https://microsoftedge.microsoft.com/addons/detail/$($ext.Name)"
            $startindex = $x.Content.IndexOf("<title>")
            $stopindex = $x.Content.IndexOf("</title>")
        }
 
        if($x.Content.Substring($startindex+7,$stopindex-$startindex-7) -like "*$chromeaddon*"){
            $output = [PSCustomObject]@{
                'Username' = $user.Name
                'Extension' = $ext.Name 
                'Browser' = "Chrome"
                'Name' = $x.Content.Substring($startindex+7,$x.Content.IndexOf($chromeaddon) - $startindex - 7)
                'Store' = "Chrome Web Store"
                'URL' = "https://chromewebstore.google.com/detail/$($ext.Name)"
                'A1_Key' = $user.Name + $ext.Name
            }
        }
        elseif($x.Content.Substring($startindex+7,$stopindex-$startindex-7) -like "*$edgeaddon*"){
            $output = [PSCustomObject]@{
                'Username' = $user.Name
                'Extension' = $ext.Name 
                'Browser' = "Chrome"
                'Name' = $x.Content.Substring($startindex+7,$x.Content.IndexOf($edgeaddon) - $startindex - 7)
                'Store' = "Microsoft Edge Addons"
                'A1_Key' = $user.Name + $ext.Name
                'URL' = "https://microsoftedge.microsoft.com/addons/detail/$($ext.Name)"
            }
        }
        else{
            $output = [PSCustomObject]@{
                'Username' = $user.Name
                'Extension' = $ext.Name 
                'Browser' = "Chrome"
                'Name' = $x.Content.Substring($startindex+7,$stopindex-$startindex-7)
                'Store' = ""
                'URL' = ""
                'A1_Key' = $user.Name + $ext.Name
            }
        }
 
        # pipeline the output object for processing
        Write-Output $output
    }
}

$IconUrl = "https://jmp.sh/s/Q3J9B4yuJjFduO6zR9iq"
$ShortcutName = "EssentialEd.lnk"                    # name on desktop
# ————————————————

$PublicPictures = Join-Path $env:Public 'Pictures'
if (!(Test-Path $PublicPictures)) {
    New-Item -Path $PublicPictures -ItemType Directory -Force | Out-Null
}
$IconPath = Join-Path $PublicPictures 'ed_icon.ico'

Invoke-WebRequest -Uri $IconUrl -OutFile $IconPath -UseBasicParsing -ErrorAction Stop

$possible = @(
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
)
$ChromeExe = $possible | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $ChromeExe) { throw "Chrome not found." }

$desktop = [Environment]::GetFolderPath('CommonDesktopDirectory')
$lnkPath = Join-Path $desktop $ShortcutName
$Wsh = New-Object -ComObject WScript.Shell
$lnk = $Wsh.CreateShortcut($lnkPath)
$lnk.TargetPath       = $ChromeExe
$lnk.Arguments        = "https://www.essentialed.com/start/bolduc"
$lnk.IconLocation     = $IconPath
$lnk.WorkingDirectory = Split-Path $ChromeExe
$lnk.Save()

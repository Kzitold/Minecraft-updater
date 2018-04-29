$path = [Environment]::CurrentDirectory = Get-Location -PSProvider FileSystem
$launch = "..."

$mc = "..."
$server = "$path\scripts\updater\server"
$dir = "C:\Users\$env:USERNAME\AppData\Roaming\.minecraft"
$exclude = "$path\mods\$mc"

& $path\scripts\Forge.ps1
& $path\scripts\LiteLoader.ps1
& $path\scripts\OptiFine.ps1

$mv = $mc

$mod = "..."
& $path\scripts\CurseForge.ps1

Remove-Item $path\scripts\updater -recurse

#start $launch
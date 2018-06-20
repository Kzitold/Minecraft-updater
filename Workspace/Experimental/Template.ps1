$path = split-path -parent $MyInvocation.MyCommand.Definition

$mc = "..."
$launch = "..."
$profile = "..."

$exclude = "$path\mods\$mc"
$dir = "C:\Users\$env:USERNAME\AppData\Roaming\.minecraft"
$server = "$path\scripts\updater\server"

$mv = $mc
$skip = "0"

& $path\scripts\Forge.ps1
& $path\scripts\LiteLoader.ps1
& $path\scripts\OptiFine.ps1

$mod = "..."
& $path\scripts\CurseForge.ps1

Remove-Item $path\scripts\updater -recurse

#start $launch
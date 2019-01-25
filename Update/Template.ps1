$path = split-path -parent $MyInvocation.MyCommand.Definition

$mc = "..."
$launch = "..."
$profile = $mc

$exclude = "$path\mods\$mc"
$dir = "C:\Users\$env:USERNAME\AppData\Roaming\.minecraft"
$server = "$path\scripts\updater\server"

& $path\scripts\Forge.ps1
& $path\scripts\LiteLoader.ps1
& $path\scripts\OptiFine.ps1

$mv = $mc

$mod = "..."
& $path\scripts\CurseForge.ps1

#start $launch

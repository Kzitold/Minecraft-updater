$path = [Environment]::CurrentDirectory = Get-Location -PSProvider FileSystem
$launch = "..."

$mc = "1.12.2"
$server = "$path\server"
$dir = "C:\Users\$env:USERNAME\AppData\Roaming\.minecraft"
$exclude = "$path\mods\$mc"

& $path\scripts\Forge.ps1
& $path\scripts\LiteLoader.ps1
& $path\scripts\OptiFine.ps1

$mv = $mc

$mod = "armor-chroma"
& $path\scripts\CurseForge.ps1

$mod = "minecord"
& $path\scripts\CurseForge.ps1

$mod = "devotion-irc"
& $path\scripts\CurseForge.ps1

$mod = "jei"
& $path\scripts\CurseForge.ps1

$mod = "voxelmap"
& $path\scripts\CurseForge.ps1

$mod = "inventory-tweaks"
& $path\scripts\CurseForge.ps1

$mod = "minemenu"
& $path\scripts\CurseForge.ps1

$mod = "tails"
& $path\scripts\CurseForge.ps1

$mod = "wit-what-is-that"
& $path\scripts\CurseForge.ps1

$mod = "tabbychat-2"
& $path\scripts\CurseForge.ps1

$mod = "resource-pack-organizer"
& $path\scripts\CurseForge.ps1

$mod = "neat"
& $path\scripts\CurseForge.ps1

$mod = "lunatriuscore"
& $path\scripts\CurseForge.ps1

$mod = "tracer"
& $path\scripts\CurseForge.ps1

$mod = "schematica"
& $path\scripts\CurseForge.ps1

$mod = "ingame-info-xml"
& $path\scripts\CurseForge.ps1

$mod = "excore"
& $path\scripts\CurseForge.ps1

$mv = "1.12.1"

$mod = "enhanced-selection-bounding-box-mod"
& $path\scripts\CurseForge.ps1

$mv = "1.12"

$mod = "light-level-overlay-reloaded"
& $path\scripts\CurseForge.ps1

Remove-Item $path\scripts\updater -recurse

#start $launch
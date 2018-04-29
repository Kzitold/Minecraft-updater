Select-String $lib\launcher_profiles.json -pattern "selectedProfile" | Select-Object LineNumber > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt | select -last 1 -skip 2
$ver = get-content $lib\launcher_profiles.json | select -first 1 -skip ([int]$num-1)
(Get-Content $lib\launcher_profiles.json).replace("$ver", "  `"selectedProfile`": `"$profile`",") | Set-Content $lib\launcher_profiles.json
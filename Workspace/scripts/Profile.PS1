$num = Select-String $lib\launcher_profiles.json -pattern "$profile" | select -first 1 | Select-Object -ExpandProperty LineNumber
$num = ((Get-Content $lib\launcher_profiles.json| Select-Object -Skip $num) | Select-String -pattern "lastUsed" | select -first 1 | Select-Object -ExpandProperty LineNumber) + $num
$ver = get-content $lib\launcher_profiles.json | select -first 1 -skip ([int]$num-1)
$time = (get-date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
(Get-Content $lib\launcher_profiles.json).replace("$ver", "      `"lastUsed`": `"$time`",") | Set-Content $lib\launcher_profiles.json
if (Test-Path "$path\scripts\updater"){Remove-Item $path\scripts\updater -recurse}
New-Item $path\scripts\updater -type directory -Force | Out-Null
New-Item $dir\mods\$mc -type directory -Force | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$client = new-object System.Net.WebClient

$client.DownloadFile("https://dl-api.spongepowered.org/v1/org.spongepowered/spongeforge/downloads?type=bleeding&minecraft=$mc","$path\scripts\updater\source.txt")

$ver = get-content "$path\scripts\updater\source.txt"
$ver = $ver -split("\[")
$ver = $ver -split("\{")
$ver = $ver -split("\}")
$ver -split("\]") > $path\scripts\updater\source.txt

Select-String $path\scripts\updater\source.txt -pattern "url" | Select-Object LineNumber > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt |select -First 1 -skip 3
$ver = get-content $path\scripts\updater\source.txt | select -first 1 -skip ([int]$num-1)
$ver = $ver -split("""")
$ver = $ver | select -first 1 -skip 3
$jar = $ver -split("/") | select -last 1

$client.DownloadFile("$ver","$dir\mods\$mc\$jar")
Copy-Item $dir\mods\$mc\$jar $server\mods  -recurse -Force | Out-Null
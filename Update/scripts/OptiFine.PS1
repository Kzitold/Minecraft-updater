$host.UI.RawUI.WindowTitle = "$profile : OptiFine"

New-Item $path\scripts\updater -type directory -Force | Out-Null
cd $path\scripts\updater
$client = new-object System.Net.WebClient

$client.DownloadFile("http://optifine.net/downloads","$path\scripts\updater\source.txt")

$num = Select-String source.txt -pattern "<h2>Minecraft $mc<" | Select-Object -ExpandProperty LineNumber
$ver = (get-content source.txt | select -first 1 -skip ([int]$num+(5))).Remove(0,40)
$ver = $ver.Remove($ver.Length-26)

$client.DownloadFile("$ver","$path\scripts\updater\source.txt")

$num = Select-String source.txt -pattern downloadx | Select-Object -ExpandProperty LineNumber
===
$ver = ((get-content source.txt | select -first 1 -skip ($num-1)) -split("&")) -split("=")
$jar = $ver -split("""") | select -first 1 -skip 2
$ver = $ver -split("'") | select -first 1 -skip 5

$client.DownloadFile("http://optifine.net/downloadx?f=$jar&x=$ver","$dir\mods\$mc\$jar")

echo "$jar"
cd $path
Remove-Item $path\scripts\updater -recurse

$host.UI.RawUI.WindowTitle = "$profile : OptiFine"

if (Test-Path "$path\scripts\updater"){Remove-Item $path\scripts\updater -recurse}
New-Item $path\scripts\updater -type directory -Force | Out-Null
cd $path\scripts\updater
$client = new-object System.Net.WebClient

$client.DownloadFile("http://optifine.net/downloads","$path\scripts\updater\source.txt")

Select-String source.txt -pattern "<h2>Minecraft $mc<" | Select-Object LineNumber > num.txt
$num = get-content num.txt |select -First 1 -skip 3
$mc = get-content source.txt | select -first 1 -skip ([int]$num-1)
$mc = $mc -split("<") -split(" ") | select -first 1 -skip 2
$ver = get-content source.txt | select -first 1 -skip ([int]$num+(5+([int]$skip*7)))
$ver = $ver.Remove(0,40)
$ver = $ver.Remove($ver.Length-26)

$client.DownloadFile("$ver","$path\scripts\updater\source.txt")

Select-String source.txt -pattern downloadx | Select-Object LineNumber > num.txt
$num = get-content num.txt | select -first 1 -skip 3
$ver = get-content source.txt | select -first 1 -skip ($num-1)
$ver = $ver -split("&")
$ver = $ver -split("=")
$jar = $ver -split("""") | select -first 1 -skip 2
$ver = $ver -split("'") | select -first 1 -skip 5

$client.DownloadFile("http://optifine.net/downloadx?f=$jar&x=$ver","$dir\mods\$mc\$jar")

echo "$jar"
cd $path
$host.UI.RawUI.WindowTitle = "$profile : $mod"

$updater = "$path\scripts\updater"
New-Item $updater -type directory -Force | Out-Null
cd $updater
$client = new-object System.Net.WebClient

$mod = "https://minecraft.curseforge.com/projects/$mod/files"

$client.DownloadFile("$mod/files","$updater\source.txt")

$num = Select-String $updater\source.txt -pattern "  $mv</option>" -SimpleMatch | Select-Object -ExpandProperty LineNumber
$ver = ((get-content $updater\source.txt | select -first 1 -skip ([int]$num-3)).Remove(0,11)).split("""")

$mod = "$mod`?filter-game-version=$ver"

$client.DownloadFile($mod,"$updater\source.txt")

$num = Select-String $updater\source.txt -pattern "col-downloads" | Select-Object -ExpandProperty LineNumber

$ver = get-content $updater\source.txt | select -first 1 -skip ($num+28)
$ver.split('"') > $updater\source.txt
$num = Select-String $updater\source.txt -pattern "href" | Select-Object -ExpandProperty LineNumber
$ver = get-content $updater\source.txt | select -first 1 -skip ($num)

$client.DownloadFile("https://minecraft.curseforge.com$ver","$updater\source.txt")

$num = Select-String $updater\source.txt -pattern "Filename" | Select-Object -ExpandProperty LineNumber

$jar = ((get-content $updater\source.txt | select -first 1 -skip ($num)).split(">") | select -first 1 -skip 1).split("<") | select -first 1

$client.DownloadFile("https://minecraft.curseforge.com$ver/download","$dir\mods\$mc\$jar")

echo "$jar"
cd $path
Remove-Item $updater -recurse

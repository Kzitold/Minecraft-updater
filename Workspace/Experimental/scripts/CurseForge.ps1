$host.UI.RawUI.WindowTitle = "$profile : $mod"

if (Test-Path "$path\scripts\updater"){Remove-Item $path\scripts\updater -recurse}
New-Item $path\scripts\updater -type directory -Force | Out-Null
cd $path\scripts\updater
$client = new-object System.Net.WebClient

$mod = "https://minecraft.curseforge.com/projects/$mod/files"

$client.DownloadFile("$mod/files","$path\scripts\updater\source.txt")

Select-String source.txt -pattern "  $mv</option>" -SimpleMatch | Select-Object LineNumber > num.txt
$num = get-content num.txt | select -Last 3 | select -First 1
$ver = get-content source.txt | select -first 1 -skip ([int]$num-3)
$ver = $ver.Remove(0,11)
$ver = $ver.Remove($ver.Length-1)
$mod = "$mod`?filter-game-version=$ver"

$client.DownloadFile($mod,"$path\scripts\updater\source.txt")

Select-String source.txt -pattern "col-downloads" | Select-Object LineNumber > num.txt
$num = get-content num.txt | select -Last 3 | select -First 1
$ver = get-content source.txt | select -first 1 -skip ([int]$num+(28+([int]$skip*50)))
$ver.split('"') > source.txt
Select-String source.txt -pattern "href" | Select-Object LineNumber > num.txt
$num = get-content num.txt | select -Last 3 | select -First 1
$ver = get-content source.txt | select -first 1 -skip ([int]$num)

$client.DownloadFile("https://minecraft.curseforge.com$ver","$path\scripts\updater\source.txt")

Select-String source.txt -pattern "Filename" | Select-Object LineNumber > num.txt
$num = get-content num.txt | select -Last 3 | select -First 1
$jar = get-content source.txt | select -first 1 -skip ([int]$num)
$jar = $jar.split(">") | select -first 1 -skip 1
$jar = $jar.split("<") | select -first 1

$client.DownloadFile("https://minecraft.curseforge.com$ver/download","$dir\mods\$mc\$jar")

echo "$jar"
cd $path
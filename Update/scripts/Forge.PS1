$host.UI.RawUI.WindowTitle = "$profile : Forge"

$updater = "$path\scripts\updater"
New-Item $updater -type directory -Force | Out-Null

$lib = "$env:APPDATA\.minecraft"

$client = new-object System.Net.WebClient

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}


New-Item $exclude -type directory -Force | Out-Null
if (Test-Path "$dir\mods\$mc"){Remove-Item $dir\mods\$mc -recurse}
New-Item $dir\mods\$mc -type directory -Force | Out-Null
Copy-Item -Path "$exclude\*" -Destination "$dir\mods\$mc" -recurse -Force | Out-Null
New-Item $server -type directory -Force | Out-Null

#----------------
if (Test-Path "$server\mods")
{
Remove-Item $server\mods -recurse
}

New-Item $server\mods -type directory -Force | Out-Null
dir $server -name > $server\source.txt
if (((Get-Content "$server\source.txt") | %{$_ -match "universal"}) -contains $true) {

$num = Select-String $server\source.txt -pattern "universal" | Select-Object -ExpandProperty LineNumber
$ver = get-content $server\source.txt | select -first 1 -skip ($num-1)

Remove-Item $server\$ver -recurse
}
#----------------

$forge = "http://files.minecraftforge.net/maven/net/minecraftforge/forge/index_$mc.json"

$client.DownloadFile("$forge","$updater\source.txt")

$num = Select-String $updater\source.txt -pattern `"$mc`":`{ | Select-Object -ExpandProperty LineNumber
$fv = (get-content $updater\source.txt | select -first 1 -skip $num).split('"') | select -first 1 -skip 3

$num = Select-String $updater\source.txt -pattern path.*$fv.*installer.jar | Select-Object -ExpandProperty LineNumber
$ver = (get-content $updater\source.txt | select -first 1 -skip ($num-1)).split('"') | select -first 1 -skip 3

$jar = $ver.split("/") | select -last 1

$client.DownloadFile("http://files.minecraftforge.net/maven/net/minecraftforge/forge/$ver","$updater\$jar")

cd $server
$host.UI.RawUI.WindowTitle = "$profile : Forge..."
java -jar "$updater\$jar" --installServer | Out-Null
$host.UI.RawUI.WindowTitle = "$profile : Forge"
cd $path

Copy-Item -Path "$exclude\*" -Destination "$server\mods" -recurse -Force | Out-Null
dir $server -name > $updater\source.txt

$num = Select-String $updater\source.txt -pattern "universal" | Select-Object -ExpandProperty LineNumber
$ver = get-content $updater\source.txt | select -first 1 -skip ($num-1)

Unzip "$server\$ver" "$updater\universal"

New-Item "$lib\versions\Forge-$mc" -type directory -Force | Out-Null
New-Item "$lib\libraries\net\minecraftforge\forge\$mc" -type directory -Force | Out-Null
Copy-Item $server\libraries $lib -recurse -Force | Out-Null
Copy-Item $server\$ver $lib\libraries\net\minecraftforge\forge\$mc`\forge-$mc`.jar -recurse -Force | Out-Null

$num = Select-String $updater\universal\version.json -pattern '"id"' | Select-Object -ExpandProperty LineNumber
$id = (get-content $updater\universal\version.json | select -first 1 -skip ($num-1)).split('"') | select -last 1 -skip 1

$num = Select-String $updater\universal\version.json -pattern name.*$fv | Select-Object -ExpandProperty LineNumber
$ver = (get-content $updater\universal\version.json | select -first 1 -skip ([int]$num-1)).split('"') | select -last 1 -skip 1

((Get-Content $updater\universal\version.json).replace("`"id`": `"$id`"", "`"id`": `"Forge-$mc`"")).replace("$ver", "net.minecraftforge:forge:$mc") | Set-Content $lib\versions\Forge-$mc`\Forge-$mc`.json
Copy-Item $lib\versions\$mc`\$mc`.jar $lib\versions\Forge-$mc`\Forge-$mc`.jar -recurse -Force | Out-Null

echo "forge-$mc`.jar"
cd $path
Remove-Item $updater -recurse

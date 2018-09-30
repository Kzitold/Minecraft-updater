New-Item $path\scripts\updater -type directory -Force | Out-Null
$lib = "C:\Users\$env:USERNAME\AppData\Roaming\.minecraft"
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
Select-String $server\source.txt -pattern "universal" | Select-Object LineNumber > $server\num.txt
$num = get-content $server\num.txt | select -last 1 -skip 2
$ver = get-content $server\source.txt | select -first 1 -skip ([int]$num-1)
Remove-Item $server\$ver -recurse
}
#----------------

$forge = "http://files.minecraftforge.net/maven/net/minecraftforge/forge/index_$mc.json"

$client.DownloadFile("$forge","$path\scripts\updater\source.txt")

Select-String $path\scripts\updater\source.txt -pattern `"$mc`":`{ | Select-Object LineNumber > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt | select -last 1 -skip 2
$ver = get-content $path\scripts\updater\source.txt | select -first 1 -skip $num
$ver = $ver.split('"') | select -first 1 -skip 3
$fv = $ver

Select-String $path\scripts\updater\source.txt -pattern path.*$ver.*installer.jar | Select-Object LineNumber > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt | select -last 1 -skip 2
$ver = get-content $path\scripts\updater\source.txt | select -first 1 -skip ([int]$num-1)
$ver = $ver.split('"') | select -first 1 -skip 3
$jar = $ver.split("/") | select -last 1

$client.DownloadFile("http://files.minecraftforge.net/maven/net/minecraftforge/forge/$ver","$path\scripts\updater\$jar")

cd $server
java -jar "$path\scripts\updater\$jar" --installServer
cd $path

Copy-Item -Path "$exclude\*" -Destination "$server\mods" -recurse -Force | Out-Null

dir $server -name > $path\scripts\updater\source.txt
Select-String $path\scripts\updater\source.txt -pattern "universal" | Select-Object LineNumber > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt | select -last 1 -skip 2
$ver = get-content $path\scripts\updater\source.txt | select -first 1 -skip ([int]$num-1)

Unzip "$server\$ver" "$path\scripts\updater\universal"

New-Item "$lib\versions\Forge-$mc" -type directory -Force | Out-Null
New-Item "$lib\libraries\net\minecraftforge\forge\$mc" -type directory -Force | Out-Null
Copy-Item $server\libraries $lib -recurse -Force | Out-Null
Copy-Item $server\$ver $lib\libraries\net\minecraftforge\forge\$mc`\forge-$mc`.jar -recurse -Force | Out-Null

Select-String $path\scripts\updater\universal\version.json -pattern '"id"' | Select-Object LineNumber  > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt | select -last 1 -skip 2
$id = get-content $path\scripts\updater\universal\version.json | select -first 1 -skip ([int]$num-1)
$id = $id.split('"') | select -last 1 -skip 1
(Get-Content $path\scripts\updater\universal\version.json).replace("`"id`": `"$id`"", "`"id`": `"Forge-$mc`"") | Set-Content $path\scripts\updater\universal\version.json

Select-String $path\scripts\updater\universal\version.json -pattern name.*$fv | Select-Object LineNumber > $path\scripts\updater\num.txt
$num = get-content $path\scripts\updater\num.txt | select -Last 1 -skip 2
$ver = get-content $path\scripts\updater\universal\version.json | select -first 1 -skip ([int]$num-1)
$ver = $ver.split('"') | select -last 1 -skip 1
(Get-Content $path\scripts\updater\universal\version.json).replace("$ver", "net.minecraftforge:forge:$mc") | Set-Content $lib\versions\Forge-$mc`\Forge-$mc`.json

Copy-Item $lib\versions\$mc`\$mc`.jar $lib\versions\Forge-$mc`\Forge-$mc`.jar -recurse -Force | Out-Null

echo "forge-$mc`.jar"
cd $path
Remove-Item $path\scripts\updater -recurse

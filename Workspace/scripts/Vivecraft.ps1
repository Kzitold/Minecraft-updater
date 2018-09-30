$host.UI.RawUI.WindowTitle = "$profile : ViveForge"

New-Item $path\scripts\updater -type directory -Force | Out-Null

$client = new-object System.Net.WebClient
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ver = $mc
$num = ($mc.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count

If ($num -eq 2) {
$ver = $mc.Remove($mc.length-(($mc -split('\.') | select -skip 2).length))
}

$ver = $ver.replace('.', "")
$git = "https://github.com/jrbudda/Vivecraft_$ver/releases/latest"

$client.DownloadFile("$git","$path\scripts\updater\source.txt")
$num = Select-String $path\scripts\updater\source.txt -pattern download.*installer.exe | select-string -pattern 'NONVR' -notmatch | Select-Object -ExpandProperty LineNumber
$ver = get-content $path\scripts\updater\source.txt | select -first 1 -skip ([int]$num-1)

$num = $ver -split("""") | select-string -pattern 'href' | Select-Object -ExpandProperty LineNumber
$git = $ver -split("""") | select -first 1 -skip $num

$client.DownloadFile("https://github.com$git","$path\scripts\updater\install.exe")

start $path\scripts\updater\install.exe
Start-Sleep 5
$nid = (Get-Process javaw).id
Wait-Process -Id $nid

$vf = "$dir\versions\ViveForge-$mc"
New-Item "$vf" -type directory -Force | Out-Null

$ver = ($git -split("/") | select-string -pattern 'exe') -replace("installer.exe","forge")
(Get-Content $dir\versions\$ver\$ver.json).replace("forge:$mc-","forge:$mc") | Set-Content $vf\ViveForge-$mc.json
Copy-Item $dir\versions\$ver\$ver.jar $vf\ViveForge-$mc.jar -recurse -Force | Out-Null

(Get-Content $vf\ViveForge-$mc.json).replace("`"id`": `"$ver`"", "`"id`": `"ViveForge-$mc`"") | Set-Content $vf\ViveForge-$mc.json
Remove-Item $dir\versions\$ver -recurse

echo "ViveForge-$mc`.jar"
cd $path
Remove-Item $path\scripts\updater -recurse
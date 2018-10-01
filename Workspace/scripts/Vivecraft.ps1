$host.UI.RawUI.WindowTitle = "$profile : ViveForge"

$updater = "$path\scripts\updater"
New-Item $updater -type directory -Force | Out-Null

$client = new-object System.Net.WebClient
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ver = $mv
$num = ($mv.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count

If ($num -eq 2) {
$ver = $mv.Remove($mv.length-(($mv -split('\.') | select -skip 2).length))
}

$ver = $ver.replace('.', "")
$git = "https://github.com/jrbudda/Vivecraft_$ver/releases/latest"

$client.DownloadFile("$git","$updater\source.txt")

$num = Select-String $updater\source.txt -pattern download.*installer.exe | select-string -pattern 'NONVR' -notmatch | Select-Object -ExpandProperty LineNumber
$ver = get-content $updater\source.txt | select -first 1 -skip ($num-1)

$num = $ver -split("""") | select-string -pattern 'href' | Select-Object -ExpandProperty LineNumber
$git = $ver -split("""") | select -first 1 -skip $num

$client.DownloadFile("https://github.com$git","$updater\install.exe")

start $updater\install.exe
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
Remove-Item $updater -recurse
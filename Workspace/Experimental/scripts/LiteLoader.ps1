$host.UI.RawUI.WindowTitle = "$profile : LiteLoader"

if (Test-Path "$path\scripts\updater"){Remove-Item $path\scripts\updater -recurse}
New-Item $path\scripts\updater -type directory -Force | Out-Null
$client = new-object System.Net.WebClient
$jar = "liteloader-installer-$mv-00-SNAPSHOT.jar"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$client.DownloadFile("http://jenkins.liteloader.com/job/LiteLoaderInstaller%20$mv/lastSuccessfulBuild/artifact/build/libs/$jar","$path\scripts\updater\$jar")

Unzip "$path\scripts\updater\$jar" "$path\scripts\updater\liteloader-$mv"
Copy-Item $path\scripts\updater\liteloader-$mv\liteloader-$mv-SNAPSHOT-release.jar $dir\mods\$mc\liteloader-$mv-SNAPSHOT-release.jar -recurse

echo "liteloader-$mv-SNAPSHOT-release.jar"
cd $path
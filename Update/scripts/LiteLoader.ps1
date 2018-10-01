$host.UI.RawUI.WindowTitle = "$profile : LiteLoader"

$updater = "$path\scripts\updater"
New-Item $updater -type directory -Force | Out-Null
$client = new-object System.Net.WebClient
$jar = "liteloader-installer-$mv-00-SNAPSHOT.jar"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$client.DownloadFile("http://jenkins.liteloader.com/job/LiteLoaderInstaller%20$mv/lastSuccessfulBuild/artifact/build/libs/$jar","$updater\$jar")

Unzip "$updater\$jar" "$updater\liteloader-$mv"
Copy-Item $updater\liteloader-$mv\liteloader-$mv-SNAPSHOT-release.jar $dir\mods\$mc\liteloader-$mv-SNAPSHOT-release.jar -recurse

Remove-Item $updater -recurse
echo "liteloader-$mv-SNAPSHOT-release.jar"
cd $path

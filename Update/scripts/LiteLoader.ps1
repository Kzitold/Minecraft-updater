New-Item $path\scripts\updater -type directory -Force | Out-Null
$client = new-object System.Net.WebClient
$jar = "liteloader-installer-$mc-00-SNAPSHOT.jar"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$client.DownloadFile("http://jenkins.liteloader.com/job/LiteLoaderInstaller%20$mc/lastSuccessfulBuild/artifact/build/libs/$jar","$path\scripts\updater\$jar")

Unzip "$path\scripts\updater\$jar" "$path\scripts\updater\liteloader-$mc"
Copy-Item $path\scripts\updater\liteloader-$mc\liteloader-$mc-SNAPSHOT-release.jar $dir\mods\$mc\liteloader-$mc-SNAPSHOT-release.jar -recurse

echo "liteloader-$mc-SNAPSHOT-release.jar"
cd $path
Remove-Item $path\scripts\updater -recurse

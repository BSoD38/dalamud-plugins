param([Parameter(Mandatory)][string]$BuildDir)
$ErrorActionPreference = 'Stop'

$name = Split-Path $BuildDir -Leaf
$dest = Join-Path $PSScriptRoot "plugins\$name"
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item (Join-Path $BuildDir "$name.json") $dest
Copy-Item (Join-Path $BuildDir 'latest.zip') $dest

$base = 'https://raw.githubusercontent.com/BSoD38/dalamud-plugins/main/plugins'
$entries = Get-ChildItem (Join-Path $PSScriptRoot 'plugins\*\*.json') | ForEach-Object {
    $m = Get-Content $_.FullName -Raw | ConvertFrom-Json
    $link = "$base/$($m.InternalName)/latest.zip"
    $zip = Get-Item (Join-Path $_.DirectoryName 'latest.zip')
    $m | Add-Member -Force -NotePropertyMembers @{
        DownloadLinkInstall = $link
        DownloadLinkUpdate  = $link
        DownloadLinkTesting = $link
        LastUpdate          = [DateTimeOffset]::new($zip.LastWriteTimeUtc).ToUnixTimeSeconds()
    }
    $m
}
# -InputObject keeps a single entry as a JSON array; Dalamud rejects a bare object.
$json = ConvertTo-Json -InputObject @($entries) -Depth 5
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'pluginmaster.json'), $json + "`n")

$version = (Get-Content (Join-Path $dest "$name.json") -Raw | ConvertFrom-Json).AssemblyVersion
git -C $PSScriptRoot add -A
git -C $PSScriptRoot commit -m "$name $version"
git -C $PSScriptRoot push

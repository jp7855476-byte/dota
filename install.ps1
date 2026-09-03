param(
    [Parameter(Mandatory=$true)]
    [string]$DotaPath
)

$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "dota2ai\dota\scripts\vscripts\bots"
$target = Join-Path $DotaPath "game\dota\scripts\vscripts\bots"

if (!(Test-Path $source)) { throw "Source directory not found: $source" }
if (!(Test-Path $target)) { New-Item -ItemType Directory -Force -Path $target | Out-Null }

Copy-Item -Path (Join-Path $source "*") -Destination $target -Recurse -Force
Write-Host "DotaAI installed to $target"

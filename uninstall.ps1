param(
    [Parameter(Mandatory=$true)]
    [string]$DotaPath
)

$ErrorActionPreference = "Stop"
$target = Join-Path $DotaPath "game\dota\scripts\vscripts\bots"

@("bot_generic.lua","hero_selection.lua","ability_item_usage_generic.lua",
  "item_purchase_generic.lua","mode_laning_generic.lua","dotaai") | ForEach-Object {
    $p = Join-Path $target $_
    if (Test-Path $p) { Remove-Item -Recurse -Force $p }
}

Write-Host "DotaAI files removed."

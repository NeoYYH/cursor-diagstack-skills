# Install ass (ASS) skill to user skill dirs Cursor actually scans.
param(
    [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$SkillName = "ass"
$SkillSrc = Join-Path $RepoRoot "skills\$SkillName"

if (-not (Test-Path $SkillSrc)) {
    Write-Error "Skill source not found: $SkillSrc"
}

function Get-PathKey([string]$Path) {
    return $Path.TrimEnd('\', '/').ToLowerInvariant()
}

function Install-To([string]$Root) {
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    $dst = Join-Path $Root $SkillName
    $keepKey = Get-PathKey $dst

    foreach ($legacy in @("ASS", "dsc-a", "dsc-b", "diagstack-c-comment-style", "Ass")) {
        $p = Join-Path $Root $legacy
        if (-not (Test-Path $p)) { continue }
        if ((Get-PathKey $p) -eq $keepKey) {
            Write-Host "Skip legacy remove (same path as target): $p"
            continue
        }
        Remove-Item -Recurse -Force $p
        Write-Host "Removed legacy: $p"
    }

    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    Copy-Item -Recurse -Force (Join-Path $SkillSrc "*") $dst

    $skillMd = Join-Path $dst "SKILL.md"
    if (-not (Test-Path $skillMd)) {
        Write-Error "SKILL.md missing after install: $skillMd"
    }
    Write-Host "Installed: $dst"
}

Install-To (Join-Path $env:USERPROFILE ".cursor\skills")
Install-To (Join-Path $env:USERPROFILE ".agents\skills")

Write-Host ""
Write-Host "Verify with:"
Write-Host "  dir `$env:USERPROFILE\.cursor\skills\ass\SKILL.md"
Write-Host "  dir `$env:USERPROFILE\.agents\skills\ass\SKILL.md"
Write-Host ""
Write-Host "Then FULLY quit Cursor and reopen. New chat invoke: @ass  or  ASS  or  A"

# Install art (ART) skill to user skill dirs Cursor actually scans.
param(
    [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"
$SkillName = "art"
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

    foreach ($legacy in @("ass", "ASS", "Ass", "ART", "dsc-a", "dsc-b", "diagstack-c-comment-style")) {
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
    $author = Join-Path $dst "AUTHOR"
    if (-not (Test-Path $author)) {
        Write-Error "AUTHOR missing after install: $author"
    }
    Write-Host "Installed: $dst"
}

function Install-Alias([string]$Root, [string]$Name) {
    $src = Join-Path $RepoRoot "skills\$Name"
    if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
        Write-Error "Skill source not found: $src"
    }
    $dst = Join-Path $Root $Name
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    Copy-Item -Recurse -Force (Join-Path $src "*") $dst
    if (-not (Test-Path (Join-Path $dst "SKILL.md"))) {
        Write-Error "SKILL.md missing after install: $dst"
    }
    Write-Host "Installed: $dst"
}

foreach ($root in @(
    (Join-Path $env:USERPROFILE ".cursor\skills"),
    (Join-Path $env:USERPROFILE ".agents\skills")
)) {
    Install-To $root
    Install-Alias $root "artstd"
    Install-Alias $root "art_std"
}

Write-Host ""
Write-Host "Verify with:"
Write-Host "  dir `$env:USERPROFILE\.cursor\skills\art\SKILL.md"
Write-Host "  dir `$env:USERPROFILE\.cursor\skills\artstd\SKILL.md"
Write-Host "  dir `$env:USERPROFILE\.cursor\skills\art_std\SKILL.md"
Write-Host ""
Write-Host "Then FULLY quit Cursor and reopen. New chat: @art or /art. Rename: @ArtStd or /ArtStd"

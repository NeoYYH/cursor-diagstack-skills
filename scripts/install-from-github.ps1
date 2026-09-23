# One-shot: download ass skill from GitHub into Cursor skill dirs (no clone needed).
# PowerShell (after merge to main):
#   irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex
# Prefer the README "已验证" paste install if raw CDN caches an old script.
#
# Windows note: ASS and ass are the same path — never delete KeepPath while cleaning legacy.

param(
    [string]$Owner = "NeoYYH",
    [string]$Repo = "cursor-diagstack-skills",
    [string[]]$Refs = @(
        "main",
        "cursor/fix-ass-skill-install-d292"
    )
)

$ErrorActionPreference = "Stop"
$SkillName = "ass"
$Files = @("SKILL.md", "examples.md")

function Test-Url([string]$Url) {
    try {
        $r = Invoke-WebRequest -Uri $Url -Method Head -UseBasicParsing -TimeoutSec 15
        return ($r.StatusCode -ge 200 -and $r.StatusCode -lt 400)
    } catch {
        return $false
    }
}

function Resolve-Base {
    foreach ($ref in $Refs) {
        foreach ($dir in @("ass", "ASS")) {
            $probe = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/$dir/SKILL.md"
            Write-Host "Probe $probe"
            if (Test-Url $probe) {
                return @{
                    Ref = $ref
                    Dir = $dir
                    Base = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/$dir"
                }
            }
        }
    }
    throw "Could not find skills/ass (or ASS) SKILL.md on GitHub. Check network / repo."
}

function Get-PathKey([string]$Path) {
    return $Path.TrimEnd('\', '/').ToLowerInvariant()
}

function Remove-LegacyDirs([string]$Root, [string]$KeepPath) {
    $keepKey = Get-PathKey $KeepPath
    # On Windows ASS and ass are the same folder — never delete KeepPath.
    foreach ($legacy in @("ASS", "dsc-a", "dsc-b", "diagstack-c-comment-style", "Ass")) {
        $p = Join-Path $Root $legacy
        if (-not (Test-Path $p)) { continue }
        if ((Get-PathKey $p) -eq $keepKey) {
            Write-Host "Skip legacy remove (same path as target on this OS): $p"
            continue
        }
        Remove-Item -Recurse -Force $p -ErrorAction SilentlyContinue
        Write-Host "Removed legacy: $p"
    }
}

$resolved = Resolve-Base
Write-Host "Using ref=$($resolved.Ref) dir=$($resolved.Dir)"

function Install-FromGitHub([string]$Root) {
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    $dst = Join-Path $Root $SkillName

    # 1) Clean other legacy names first (skip if same path as dst on case-insensitive FS)
    Remove-LegacyDirs -Root $Root -KeepPath $dst

    # 2) Recreate destination AFTER cleanup
    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }
    New-Item -ItemType Directory -Force -Path $dst | Out-Null

    foreach ($f in $Files) {
        $url = "$($resolved.Base)/$f"
        $out = Join-Path $dst $f
        Write-Host "GET $url"
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
    }
    if (-not (Test-Path (Join-Path $dst "SKILL.md"))) {
        throw "Install failed: SKILL.md missing under $dst"
    }
    Write-Host "Installed: $dst"
}

Install-FromGitHub (Join-Path $env:USERPROFILE ".cursor\skills")
Install-FromGitHub (Join-Path $env:USERPROFILE ".agents\skills")

Write-Host ""
Write-Host "OK. Fully quit Cursor, reopen, NEW chat, type: @ass"
Write-Host "Check: dir $env:USERPROFILE\.cursor\skills\ass"
Write-Host "Check: dir $env:USERPROFILE\.agents\skills\ass"

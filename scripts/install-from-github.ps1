# One-shot: download ass skill from GitHub into Cursor skill dirs (no clone needed).
# PowerShell:
#   irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/cursor/fix-ass-skill-install-d292/scripts/install-from-github.ps1 | iex
# After merge to main you can also use:
#   irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex

param(
    [string]$Owner = "NeoYYH",
    [string]$Repo = "cursor-diagstack-skills",
    [string[]]$Refs = @(
        "cursor/fix-ass-skill-install-d292",
        "main"
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

$resolved = Resolve-Base
Write-Host "Using ref=$($resolved.Ref) dir=$($resolved.Dir)"

function Install-FromGitHub([string]$Root) {
    $dst = Join-Path $Root $SkillName
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    foreach ($legacy in @("ASS", "dsc-a", "dsc-b", "diagstack-c-comment-style")) {
        $p = Join-Path $Root $legacy
        if (Test-Path $p) {
            Remove-Item -Recurse -Force $p -ErrorAction SilentlyContinue
            Write-Host "Removed legacy: $p"
        }
    }
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

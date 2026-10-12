# One-shot: download art skill from GitHub into Cursor skill dirs (no clone needed).
# PowerShell (after merge to main):
#   irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex
# Prefer the README "已验证" paste install if raw CDN caches an old script.
#
# Windows note: ART and art are the same path — never delete KeepPath while cleaning legacy.
# ass and art are different paths, so the old ass directory is removed.

param(
    [string]$Owner = "NeoYYH",
    [string]$Repo = "cursor-diagstack-skills",
    [string[]]$Refs = @(
        "cursor/ass-author-revision-70e2",
        "main"
    )
)

$ErrorActionPreference = "Stop"
$SkillName = "art"
$Files = @("SKILL.md", "examples.md", "AUTHOR")

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
        foreach ($dir in @("art", "ART")) {
            $probe = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/$dir/SKILL.md"
            $author = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/$dir/AUTHOR"
            Write-Host "Probe $probe"
            $artstd = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/artstd/SKILL.md"
            $artStd = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/art_std/SKILL.md"
            if ((Test-Url $probe) -and (Test-Url $author) -and (Test-Url $artstd) -and (Test-Url $artStd)) {
                return @{
                    Ref = $ref
                    Dir = $dir
                    Base = "https://raw.githubusercontent.com/$Owner/$Repo/$ref/skills/$dir"
                }
            }
        }
    }
    throw "Could not find skills/art (or ART) SKILL.md on GitHub. Check network / repo."
}

function Get-PathKey([string]$Path) {
    return $Path.TrimEnd('\', '/').ToLowerInvariant()
}

function Remove-LegacyDirs([string]$Root, [string]$KeepPath) {
    $keepKey = Get-PathKey $KeepPath
    # On Windows ART and art are the same folder — never delete KeepPath.
    # ass is a different folder and should be removed.
    foreach ($legacy in @("ass", "ASS", "Ass", "ART", "dsc-a", "dsc-b", "diagstack-c-comment-style")) {
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

    $skillsRoot = "https://raw.githubusercontent.com/$Owner/$Repo/$($resolved.Ref)/skills"
    foreach ($name in @("artstd", "art_std")) {
        $alias = Join-Path $Root $name
        if (Test-Path $alias) { Remove-Item -Recurse -Force $alias }
        New-Item -ItemType Directory -Force -Path $alias | Out-Null
        $url = "$skillsRoot/$name/SKILL.md"
        Write-Host "GET $url"
        Invoke-WebRequest -Uri $url -OutFile (Join-Path $alias "SKILL.md") -UseBasicParsing
        Write-Host "Installed: $alias"
    }
}

Install-FromGitHub (Join-Path $env:USERPROFILE ".cursor\skills")
Install-FromGitHub (Join-Path $env:USERPROFILE ".agents\skills")

Write-Host ""
Write-Host "OK. Fully quit Cursor, reopen, NEW chat: @art or /art. Rename: @ArtStd or /ArtStd"
Write-Host "Check: dir $env:USERPROFILE\.cursor\skills\art"
Write-Host "Check: dir $env:USERPROFILE\.cursor\skills\artstd"
Write-Host "Check: dir $env:USERPROFILE\.cursor\skills\art_std"

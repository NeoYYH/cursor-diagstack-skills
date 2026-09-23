# One-shot: download ass skill from GitHub into Cursor skill dirs (no clone needed).
# Run in PowerShell:
#   irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex
# Or after this PR merges, use branch URL if needed.

param(
    [string]$Ref = "main",
    [string]$Owner = "NeoYYH",
    [string]$Repo = "cursor-diagstack-skills"
)

$ErrorActionPreference = "Stop"
$SkillName = "ass"
$Base = "https://raw.githubusercontent.com/$Owner/$Repo/$Ref/skills/$SkillName"
$Files = @("SKILL.md", "examples.md")

function Install-FromGitHub([string]$Root) {
    $dst = Join-Path $Root $SkillName
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    foreach ($legacy in @("ASS", "dsc-a", "dsc-b", "diagstack-c-comment-style")) {
        $p = Join-Path $Root $legacy
        if (Test-Path $p) {
            Remove-Item -Recurse -Force $p -ErrorAction SilentlyContinue
        }
    }
    foreach ($f in $Files) {
        $url = "$Base/$f"
        $out = Join-Path $dst $f
        Write-Host "GET $url"
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
    }
    Write-Host "Installed: $dst"
}

Install-FromGitHub (Join-Path $env:USERPROFILE ".cursor\skills")
Install-FromGitHub (Join-Path $env:USERPROFILE ".agents\skills")

Write-Host ""
Write-Host "OK. Fully quit Cursor, reopen, new chat: @ass   (or type ASS / A)"
Write-Host "Check: dir $env:USERPROFILE\.cursor\skills\ass"

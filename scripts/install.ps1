# Install ASS skill to user global skills folder.
param(
    [string]$TargetRoot = "$env:USERPROFILE\.cursor\skills"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path $PSScriptRoot -Parent
$SkillName = "ASS"
$SkillSrc = Join-Path $RepoRoot "skills\$SkillName"
$SkillDst = Join-Path $TargetRoot $SkillName

if (-not (Test-Path $SkillSrc)) {
    Write-Error "Skill source not found: $SkillSrc"
}

New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
if (Test-Path $SkillDst) {
    Remove-Item -Recurse -Force $SkillDst
}
Copy-Item -Recurse -Force $SkillSrc $SkillDst
Write-Host "Installed: $SkillDst"

# Remove legacy skill dirs (Windows paths are case-insensitive; skip current name)
$LegacyNames = @("dsc-a", "dsc-b", "diagstack-c-comment-style")
foreach ($legacy in $LegacyNames) {
    $path = Join-Path $TargetRoot $legacy
    if (Test-Path $path) {
        # Avoid deleting ASS if somehow matched
        if ((Resolve-Path $path).Path -ne (Resolve-Path $SkillDst).Path) {
            Remove-Item -Recurse -Force $path
            Write-Host "Removed legacy: $path"
        }
    }
}

Write-Host "Restart Cursor or start a new chat."
Write-Host "Invoke (case-insensitive): @ASS | /ASS | ASS | A"

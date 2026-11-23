param(
    [ValidateSet('User', 'Project')]
    [string]$Scope = 'User',
    [ValidateSet('Auto', 'Domestic', 'International', 'Both')]
    [string]$Edition = 'Auto'
)

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$Source = Join-Path $Root 'skills\modern-web-guidance'
$SkillMd = Join-Path $Source 'SKILL.md'

if (-not (Test-Path -LiteralPath $SkillMd)) {
    throw "Source skill not found: $SkillMd"
}

function Get-Targets {
    param([string]$ScopeValue, [string]$EditionValue)

    if ($ScopeValue -eq 'Project') {
        return @((Join-Path (Get-Location).Path '.codebuddy\skills'))
    }

    $Domestic = Join-Path $env:USERPROFILE '.workbuddy\skills'
    $International = Join-Path $env:USERPROFILE '.workbuddy-ai\skills'

    switch ($EditionValue) {
        'Domestic' { return @($Domestic) }
        'International' { return @($International) }
        'Both' { return @($Domestic, $International) }
        default {
            $Found = @()
            if (Test-Path -LiteralPath (Split-Path -Parent $Domestic)) { $Found += $Domestic }
            if (Test-Path -LiteralPath (Split-Path -Parent $International)) { $Found += $International }
            if ($Found.Count -eq 0) { $Found += $Domestic }
            return $Found
        }
    }
}

function Install-One {
    param([string]$SkillsRoot)

    $Destination = Join-Path $SkillsRoot 'modern-web-guidance'

    if (-not (Test-Path -LiteralPath $SkillsRoot)) {
        New-Item -ItemType Directory -Force -Path $SkillsRoot | Out-Null
    }

    if (Test-Path -LiteralPath $Destination) {
        $Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $Backup = "$Destination.backup-$Stamp"
        Move-Item -LiteralPath $Destination -Destination $Backup
        Write-Host "[INFO] Existing skill backed up to: $Backup"
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force

    if (-not (Test-Path -LiteralPath (Join-Path $Destination 'SKILL.md'))) {
        throw "Installation verification failed: SKILL.md missing at $Destination"
    }

    Write-Host "[OK] Installed WorkBuddy skill to: $Destination"
}

$Targets = @(Get-Targets -ScopeValue $Scope -EditionValue $Edition)

foreach ($Target in $Targets) {
    Install-One -SkillsRoot $Target
}

Write-Host "[OK] Scope: $Scope"
Write-Host "[OK] Edition: $Edition"
Write-Host ("[OK] Target count: " + $Targets.Count)
Write-Host 'Next: fully restart WorkBuddy, then open a new session.'

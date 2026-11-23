param(
    [ValidateSet('User', 'Project')]
    [string]$Scope = 'User',
    [ValidateSet('Auto', 'Domestic', 'International', 'Both')]
    [string]$Edition = 'Auto'
)

$ErrorActionPreference = 'Stop'

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

$Targets = @(Get-Targets -ScopeValue $Scope -EditionValue $Edition)
$Installed = @()

foreach ($SkillsRoot in $Targets) {
    $Destination = Join-Path $SkillsRoot 'modern-web-guidance'
    $SkillMd = Join-Path $Destination 'SKILL.md'

    if (-not (Test-Path -LiteralPath $SkillMd)) {
        continue
    }

    $Content = Get-Content -Raw -LiteralPath $SkillMd

    if ($Content -notmatch '(?m)^name:\s*modern-web-guidance\s*$') {
        throw "Invalid SKILL.md at $SkillMd: missing or incorrect name field"
    }

    if ($Content -notmatch '(?m)^agent_created:\s*true\s*$') {
        throw "Invalid SKILL.md at $SkillMd: missing agent_created: true"
    }

    $GuideCount = @(Get-ChildItem -LiteralPath (Join-Path $Destination 'guides') -Recurse -File -Filter '*.md').Count
    if ($GuideCount -lt 50) {
        throw "Guide corpus looks incomplete at $Destination`: only $GuideCount markdown files found"
    }

    Write-Host "[OK] Skill directory: $Destination"
    Write-Host "[OK] SKILL.md metadata"
    Write-Host ("[OK] Guide files: " + $GuideCount)
    $Installed += $Destination
}

if ($Installed.Count -eq 0) {
    throw "Skill not installed in any expected target. Run install.ps1 first."
}

$NodeVersion = & node --version
if ($LASTEXITCODE -ne 0) {
    throw "Node.js not found or failed to execute"
}
Write-Host "[OK] Node.js: $NodeVersion"

Write-Host '[INFO] Running CLI search smoke test...'
& npx.cmd -y modern-web-guidance@latest search "dialog light dismiss"
if ($LASTEXITCODE -ne 0) {
    throw "modern-web-guidance CLI search failed"
}

Write-Host ('[OK] Verified targets: ' + $Installed.Count)
Write-Host '[OK] CLI search succeeded'
Write-Host '[OK] WorkBuddy skill installation verified'

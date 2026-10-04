[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Repo,
    [Parameter(Mandatory)]
    [string]$Maintainer,
    [string[]]$RequiredCheck = @('Validate Agentic Workflows')
)

$ErrorActionPreference = 'Stop'

function Invoke-GhApi {
    param([string]$Method, [string]$Endpoint, [string]$Body)
    $arguments = @('api', '--method', $Method, $Endpoint)
    if ($Body) { $arguments += @('--input', '-') }
    if ($Body) { $Body | & gh @arguments 2>&1 | Out-String | Write-Verbose } else { & gh @arguments 2>&1 | Out-String | Write-Verbose }
    if ($LASTEXITCODE -ne 0) { throw "gh api $Method $Endpoint failed with exit code $LASTEXITCODE." }
}

function Test-GhApi {
    param([string]$Endpoint)
    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & gh api $Endpoint 1>$null 2>$null
        return $LASTEXITCODE -eq 0
    } finally {
        $ErrorActionPreference = $previousPreference
    }
}

$labels = @(
    'plan-requested', 'plan-proposed', 'plan-approved-small', 'plan-approved-design',
    'design-proposed', 'design-approved', 'implementation-proposed', 'review-requested',
    'review-proposed', 'ci-triage-requested', 'ci-triage-proposed', 'release-requested',
    'release-proposed', 'incident-triage-requested', 'incident-proposed'
)

foreach ($label in $labels) {
    $endpoint = "repos/$Repo/labels/$([uri]::EscapeDataString($label))"
    if (Test-GhApi $endpoint) {
        Write-Output "Unchanged label: $label"
    } else {
        Invoke-GhApi -Method 'POST' -Endpoint "repos/$Repo/labels" -Body (@{ name = $label; color = '1D76DB'; description = 'AI-DLC workflow state' } | ConvertTo-Json)
        Write-Output "Created label: $label"
    }
}

$maintainerId = gh api "users/$Maintainer" --jq '.id'
$environmentBody = @{ reviewers = @(@{ type = 'User'; id = [int64]$maintainerId }); deployment_branch_policy = $null } | ConvertTo-Json -Depth 4
Invoke-GhApi -Method 'PUT' -Endpoint "repos/$Repo/environments/production" -Body $environmentBody
Write-Output 'Ensured production environment with maintainer reviewer.'

if ($RequiredCheck.Count -eq 0) { throw 'At least one required status check is required to protect main.' }
$protection = @{
    required_status_checks = @{ strict = $true; contexts = $RequiredCheck }
    enforce_admins = $true
    required_pull_request_reviews = @{ dismissal_restrictions = @{}; dismiss_stale_reviews = $false; require_code_owner_reviews = $false; required_approving_review_count = 1; require_last_push_approval = $false }
    restrictions = $null
    required_linear_history = $false
    allow_force_pushes = $false
    allow_deletions = $false
    block_creations = $false
    required_conversation_resolution = $false
    lock_branch = $false
    allow_fork_syncing = $false
}
Invoke-GhApi -Method 'PUT' -Endpoint "repos/$Repo/branches/main/protection" -Body ($protection | ConvertTo-Json -Depth 8)
Write-Output 'Ensured main branch protection: pull request, one approval, required checks, and no force pushes.'
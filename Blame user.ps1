function Blame-User {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch sign-in logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmail
        )

    $userSignInLogs = get-mgauditlogsignin -Filter "UserPrincipalName eq '$userEmail'"

    $userSignInLogs | Select-Object @{Name='Date'; Expression={$_.CreatedDateTime}}, `
    @{Name='Name'; Expression={$_.UserDisplayName}}, `
    @{Name='App'; Expression={$_.AppDisplayName}}, `
    @{Name='Successful'; Expression={
        if ($_.Status.ErrorCode) { 
        return "No: $($_.Status.FailureReason)"
        } else {
            return 'Yes'
        }
    }}, @{Name="CA Policy"; Expression={
        $failedCAPolicies = @()
        foreach ($policy in $_.AppliedConditionalAccessPolicies) {
            if ($policy.EnforcedGrantControls -eq 'Block') {
                $failedCAPolicies += $policy.DisplayName
            }
        }
        return $failedCAPolicies
    }}, @{Name="Location"; Expression={$_.Location.CountryOrRegion}} | Format-Table
}

Connect-MgGraph -Scopes Directory.Read.All, AuditLog.Read.All, Policy.Read.ConditionalAccess
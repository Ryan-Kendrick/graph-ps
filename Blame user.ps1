function Blame-User {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch sign-in logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
    )

    

}
# $logs = get-mgauditlogsignin -Filter "startsWith(userPrincipalName, 'ryan')"
# $logs | Select-Object CreatedDateTime UserDisplayName, AppDisplayName, Status, ConditionalAccessStatus, AppliedConditionalAccessPolicies, Location | ft
# Expand property location and extract CountryOrRegion
# Dig into AppliedConditionalAccessPolicies to print DisplayName where Result is failure

Connect-MgGraph -Scopes Directory.Read.All, AuditLog.Read.All, Policy.Read.ConditionalAccess
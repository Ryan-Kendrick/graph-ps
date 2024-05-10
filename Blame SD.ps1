function Blame-SD {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch audit logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
        )



}

Connect-MgGraph -Scopes AuditLog.Read.All

# Get-MgAuditLogDirectoryAudit -filter "activityDisplayName eq 'Add member to group' or activityDisplayName eq 'Remove member from group' and TargetResources/any(t:t/UserPrincipalName eq 'ryan.kendrick93@gmail.com')"
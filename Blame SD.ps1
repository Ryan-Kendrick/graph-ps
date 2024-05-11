function Blame-SD {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch audit logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
        )



}

Connect-MgGraph -Scopes AuditLog.Read.All

# Get-MgAuditLogDirectoryAudit -filter "(activityDisplayName eq 'Add member to group' and targetResources/any(t:t/Id eq '$groupId'))" |
# ForEach-Object { $_.TargetResources | Where-Object { $_.Type -eq "User"} | Select-Object Id }

# Get-MgAuditLogDirectoryAudit -filter "(category eq 'GroupManagement' and targetResources/any(t:t/Id eq '349e03e9-1bba-4976-8901-70229c4c0cb3'))"
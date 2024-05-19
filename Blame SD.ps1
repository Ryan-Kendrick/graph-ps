function Blame-SD {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch audit logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $userEmail
        )

        $userId = (Get-MgUser -Filter  "mail eq '$userEmail'").id
        $userAuditLog = Get-MgAuditLogDirectoryAudit -Filter "(category eq 'GroupManagement' and targetResources/any(t:t/id eq '$userId'))" 

        $userAuditLog | Select-Object @{Name="Time"; Expression={$_.ActivityDateTime}}, `
        @{Name="Action"; Expression={if ($true) {$_.ActivityDisplayName}}}, `
        @{Name="Group"; Expression={$_.TargetResources[0].ModifiedProperties.NewValue[1].trim("`"")}}, `
        @{Name="Target"; Expression={$_.TargetResources[0] | Select-Object -ExpandProperty UserPrincipalName}}, `
        @{Name="Admin"; Expression={$_.InitiatedBy.User.UserPrincipalName}} | Format-Table -AutoSize
    }

Connect-MgGraph -Scopes AuditLog.Read.All

# Fix empty group for remove
# Support UM actions
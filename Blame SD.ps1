function Blame-SD {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch audit logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $userEmail
        )

        $userId = (Get-MgUser -Filter  "mail eq '$userEmail'").id
        $userAuditLog = Get-MgAuditLogDirectoryAudit -Filter "(category eq 'GroupManagement' or category eq 'UserManagement') and (targetResources/any(t:t/id eq '$userId'))" 

     
        $userAuditLog | Select-Object @{Name="Time"; Expression={$_.ActivityDateTime}}, `
        @{Name="Action"; Expression={$_.ActivityDisplayName}}, `
        @{Name="Modified"; Expression={
            try {
                $path = $_.TargetResources[0].ModifiedProperties.NewValue[1].trim("`"")
                return $path
            } catch {
            }
            $path = $_.TargetResources[0].ModifiedProperties.OldValue[1].trim("`"")
            return $path
            }}, `
        @{Name="Target"; Expression={$_.TargetResources[0] | Select-Object -ExpandProperty UserPrincipalName}}, `
        @{Name="Admin"; Expression={$_.InitiatedBy.User.UserPrincipalName}} | Format-Table -AutoSize
    }

Connect-MgGraph -Scopes AuditLog.Read.All

# Conditionally add more information for UM actions
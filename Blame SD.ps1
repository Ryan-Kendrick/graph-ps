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
        @{Name="Changed"; Expression={
            try {
                $path = $_.TargetResources[0].ModifiedProperties.NewValue[1]
                return $path.trim("`"")
            } catch {
            }
            $path = $_.TargetResources[0].ModifiedProperties.OldValue[1]
            return $path.trim("`"")
            }}, `
        @{Name='New Value'; Expression={
            try {
                $path = $_.TargetResources[0].ModifiedProperties.NewValue[0]
                return $path.trim("`"", "[", "]")
            } catch {
            }
        }}, `
        @{Name="Target"; Expression={$upn = $_.TargetResources[0] | Select-Object -ExpandProperty UserPrincipalName 
            return $upn -replace '#EXT#.*', ''}}, `
        @{Name="Admin"; Expression={$_.InitiatedBy.User.UserPrincipalName.TrimStart("#EXT#")}} | Format-Table -AutoSize
    }

Connect-MgGraph -Scopes AuditLog.Read.All

# Add param for enddate
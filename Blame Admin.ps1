function Blame-Admin {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch audit logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmail,
        [Parameter(Mandatory = $false, HelpMessage = "Increase the search range from 7 days to 30 days")]
        [switch]$long
        )
        
        $userId = (Get-MgUser -Filter  "mail eq '$userEmail'").id
        $dateRange = if (!$long.IsPresent) {
            return 7
        } else {
            return 30
        }
        $auditRange = (Get-Date).AddDays($dateRange)
        write-host $auditRange

        $searchParams = @{
            Filter="(category eq 'GroupManagement' or category eq 'UserManagement') and (targetResources/any(t:t/id eq '$userId'))"
            EndDateTime = $auditRange
        }

        $userAuditLog = Get-MgAuditLogDirectoryAudit -InputObject $searchParams

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
        @{Name="Admin"; Expression={$_.InitiatedBy.User.UserPrincipalName.trim("`"", "[", "]")}} | Format-Table -AutoSize
    }

Connect-MgGraph -Scopes AuditLog.Read.All

# Add param for enddate
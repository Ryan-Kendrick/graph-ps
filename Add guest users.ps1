function Add-GuestUsers {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of names to add. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $displayName,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Comma separated list of email addresses to send guest invitations to. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
    )

    $paramNames = @("Display name", "Email address")
    $params = @($displayName, $email)

    # Validate and split comma-separated lists
    for ($i = 0; $i -lt $params.Length; $i++) { 
        if ($params[$i] -match ",") {
            $arr = $params[$i] -split ',' | ForEach-Object { $_.Trim() }
            $params[$i] = $arr
        } else {
            Throw "A required comma-separated list was not provided for $($paramNames[$i])."
        }
    } 
    
    # Validate display names
    foreach ($namePair in $params[0]) { 
        $spacePos = $namePair.IndexOf(' ') 
        if  (!(($spacePos -ge 0) -and ($spacePos -lt ($namePair.length -1)))) {
            Throw "$namePair is not a full name"
        }
    }
    
    
    
    # Validate email addresses
    foreach ($email in $params[1]) { 
        if ($email -notmatch "^[A-Z0-9_!#$%&'*+/=?`{|}~^-]+(?:\.[A-Z0-9_!#$%&'*+/=?`{|}~^-]+↵)*@[A-Z0-9-]+(?:\.[A-Z0-9-]+)*$"
        ) {
            Throw "$email is not a valid email address"
        }
    }
    
    # Check that the lengths match
    if ($params[0].Length -ne $params[1].Length) { 
        Throw "The number of display names and email addresses must be equal."
    }
    
    
    # Prompt user for guest properties
    Write-Host "Enter the required properties for a new guest user"
    $jobTitle = Read-Host "Job title"
    $companyName = Read-Host "Company name"
    $department = Read-Host "Department"
    $managerEmail = Read-Host "Manager email address"

    $managerId = Get-MgUser -Filter "mail eq '$managerEmail'" | Select-Object -ExpandProperty Id
    if ($null -eq $managerId) {
        Throw "Manager not found for $managerEmail"
    }
    
    $props = @{
        jobTitle = $jobTitle
        companyName = $companyName
        department = $department
        usageLocation = 'NZ'
    }

    # Construct a table of the guest user accounts to be created
    $confirmationTable = @()
    for ($i = 0; $i -lt $params[0].Length; $i++) {
        $thisUser = [ordered]@{}
        for ($j = 0; $j -lt $params.Length; $j++) {
            $thisParam = $paramNames[$j]
            $thisUser.$thisParam = $params[$j][$i]
        }
        $confirmationTable += $thisUser
    }
    
    # Display table and prompt user for confirmation
    $confirmationTable | Format-Table -AutoSize | Out-Host
    $proceed = Read-Host "Enter 'y' to invite these users"
    
    # Create users
    if ($proceed -match '(?i)y') {
        $messageInfo = @{CustomizedMessageBody = "Hello. You are invited to the Contoso organization."}
        foreach ($invitee in $confirmationTable) {
            Write-host "Sending invitation to $($invitee["Display name"]) at $($invitee["Email address"])"
            $invBody = @{
                'InviteRedirectUrl' = "https://myapps.microsoft.com"
                'InvitedUserMessageInfo' = "$messageInfo"
                'InvitedUserDisplayName' = "$($invitee["Display name"])"
                'InvitedUserEmailAddress' = "$($invitee["Email address"])"
                'SendInvitationMessage' = $true
            }
            $newGuest = New-MgInvitation -BodyParameter $invBody
            Update-MgUser -UserId $newGuest.InvitedUser.Id -BodyParameter $props
            Set-MgUserManagerByRef -UserId $newGuest.InvitedUser.Id -BodyParameter @{'@odata.id' = "https://graph.microsoft.com/v1.0/users/$managerId"
        }
        }
        Write-Host "Guest accounts created. Confirm the properties are as expected in the Azure portal."
    } else {
        Write-Host "Operation aborted by user"
    }
}

Connect-MgGraph -Scopes 'User.ReadWrite.All'


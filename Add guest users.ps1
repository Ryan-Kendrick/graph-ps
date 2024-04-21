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

    for ($i = 0; $i -lt $params.Length; $i++) { # Separate each user property into an array, each element representing a different user
        if (($params[$i] | Select-String -Pattern ",") -and ($null -ne $params[$i][$params[$i].IndexOf(",")+1])) {
            $arr = $params[$i] -split ','
            $arr = $arr.Trim()
        } else {
            Throw "A required comma separated list was not provided"
        }
        $params[$i] = $arr ? $arr : $params[$i]
    } 

    if ($params[0].Length -ne $params[1].Length) { #Validate email addresses
        Throw "The length of the list of display names and email addresses must be equal"
    }
    foreach ($email in $params['email']) {

    }

    $ar1, $ar2 = $params 

    $confirmationTable = @()

    for ($i = 0; $i -lt $params[0].Length; $i++) {
        $thisUser = [ordered]@{}
        for ($j = 0; $j -lt $params.Length; $j++) {
            $thisParam = $paramNames[$j]
            $thisUser.$thisParam = $params[$j][$i]
        }
        $confirmationTable += $thisUser
    }
        
    $confirmationTable | Format-Table -AutoSize | Out-Host
    $proceed = Read-Host "Enter 'y' to invite these users"

    if ($proceed -match '(?i)y') {
        $messageInfo = @{CustomizedMessageBody = "Hello. You are invited to the Contoso organization."}
        foreach ($invitee in $confirmationTable) {
            if (($($invitee["Display name"])) -and ($null -ne $invitee["Display name"][$invitee["Display name"].IndexOf(" ")+1])) {
            Write-host "Inviting $($invitee["Display name"])"
            New-MgInvitation `
            -InviteRedirectUrl "https://myapps.microsoft.com" `
            -InvitedUserDisplayName $invitee["Display name"] `
            -InvitedUserEmailAddress $invitee["Email address"] `
            -InvitedUserMessageInfo $messageInfo `
            -SendInvitationMessage
            } else {
                Throw "$($invitee["Email address"]) lacks a valid display name"
            }
        }
    } else {
            Write-Host "Operation aborted by user"
    }
}

Connect-MgGraph -Scopes 'User.ReadWrite.All'

# add regex [a-z0-9\._%+!$&*=^|~#%'`?{}\/\-]+@([a-z0-9\-]+\.){1,}([a-z]{2,16})\
# add params for jobtitle, department, companyname, manager
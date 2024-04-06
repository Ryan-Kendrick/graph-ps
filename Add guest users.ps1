function Add-GuestUsers {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of names to add. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $displayName,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Comma separated list of email addresses to send guest invitations. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
    )
    $paramNames = @("Display name", "Email address")
    $params = @($displayName, $email)

    for ($i = 0; $i -lt $params.Length; $i++) {
        if ($params[$i] | Select-String -Pattern ",") {
            $arr = $params[$i] -split ','
            $arr = $arr.Trim()
        } else {
            Throw "Comma separated list not provided"
        }
        $params[$i] = $arr ? $arr : $params[$i]
    } 

    if ($params[0].Length -ne $params[1].Length) {
        Throw "The length of the list of display names and email addresses must be equal"
    }

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

   $messageInfo = @{CustomizedMessageBody = "Hello. You are invited to the Contoso organization."}

   foreach ($invitee in $confirmationTable) {
    New-MgInvitation `
    -InviteRedirectUrl "https://myapps.microsoft.com" `
    -InvitedUserDisplayName $invitee["Display name"] `
    -InvitedUserEmailAddress $invitee["Email address"] `
    -InvitedUserMessageInfo $messageInfo `
    -SendInvitationMessage
   }
}

Connect-MgGraph -Scopes 'User.ReadWrite.All'

# Add confirmation prompt
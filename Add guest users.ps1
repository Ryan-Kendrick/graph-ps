function Remove-UsersFromGroups {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of names to add. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $name,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Comma separated list of email addresses to send guest invitations. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
    )

    $params = @($name, $email)

    for ($i = 0; $i -lt $params.Length; $i++) {
        if ($params[$i] | Select-String -Pattern ",") {
            Write-host $params[$i]
            $arr = $params[$i] -split ','
            write-host $arr
            $arr = $arr.Trim()
        } else {
            Throw "Comma separated list not provided"
        }
        $params[$i] = $arr ? $arr : $params[$i]
    } 

    if ($params[0].Length -ne $params[1].Length) {
        Throw "The length of the list of names and email addresses must be equal"
    }

    $confirmationTable = @()

    foreach ($param in $params) {
        
    }
    # Need a length check
    # Need confirmation dialogue - array of hash tables > name: [name] email: [email]
}

# $invitations = import-csv c:\bulkinvite\invitations.csv

# $messageInfo = [Microsoft.Graph.PowerShell.Models.MicrosoftGraphInvitation]@{ `
#    CustomizedMessageBody = "Hello. You are invited to the Contoso organization." }

# foreach ($email in $invitations)
#    {New-MgInvitation `
#       -InviteRedirectUrl https://myapps.microsoft.com ` 
#       -InvitedUserDisplayName $email.Name `
#       -InvitedUserEmailAddress $email.InvitedUserEmailAddress `
#       -InvitedUserMessageInfo $messageInfo `
#       -SendInvitationMessage 
#    }
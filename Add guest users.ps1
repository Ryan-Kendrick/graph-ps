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
function Blame-User {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Email address of the user to fetch sign-in logs for. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $email
    )

    

}

Connect-MgGraph -Scopes Directory.Read.All
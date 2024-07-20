function Get-EmailAddress {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of display names to fetch email addresses for. Must be in quotes")]
        [string]$names
    )

    $namesArr = ($names -split ',').Trim()

    $emailsArr = @()
    $multipleEmailsArr = @()
    $notFoundArr = @()


    foreach ($name in $namesArr) {
      $userEmail = (Get-MgUser -Filter  "displayname eq '$name'").mail
      if ($userEmail.GetType().name -eq "Object[]") {
        $multipleEmailsArr += $name
      } elseif ($userEmail.GetType().name -eq "String") {
        $emailsArr += $userEmail
      } else {
        $notFoundArr += $name
      }
    }

    Write-Host $emailsArr

}
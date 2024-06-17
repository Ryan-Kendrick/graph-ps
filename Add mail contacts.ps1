function Add-MailContact{
  param (
      [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Display names of the users to create mail contacts for. Must be in quotes")]
      [ValidateNotNullOrEmpty()]
      [string]$displayName,

      [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Email addresses of the useres to create mail contacts for. Must be in quotes")]
      [ValidateNotNullOrEmpty()]
      [string]$email
  )

  $userEmails = ($email -split ',').Trim()
  $userNames = ($displayName -split ',').Trim()

  if ($userEmails.GetType().Name -eq 'String') {
    Throw "Multiple users expected"
  }
  
  # Check that each user has a name and a email address
  if ($userEmails.Length -ne $userNames.Length) { 
    Throw "The number of display names and email addresses must be equal."
  }

  # Validate display names
  foreach ($namePair in $userNames) { 
    $spacePos = $namePair.IndexOf(' ') 
    if  (!(($spacePos -ge 0) -and ($spacePos -lt ($namePair.Length -1)))) {
        Throw "$namePair is not a full name"
    }
  }

  Write-Host "Add an external organisation to the end of each display name or enter 'n' skip"
  do {$organisation = Read-Host "Organisation name"} while (!$organisation)
  if ($organisation -eq 'n') {$organisation = $null}

  $confirmationTable = @()
  for ($i = 0; $i -lt $userEmails.Length; $i++) {
    $confirmationTable += [PSCustomObject]@{
        'Display name' = $userNames[$i]
        'Email address' = $userEmails[$i]
    }
  }
  $confirmationTable | Format-Table -AutoSize
  $proceed = Read-Host "Enter 'y' to create these $($userEmails.Length) contacts"
  
  # Define the property values and create mail contact for each user
  if ($proceed -match '(?i)y') {
    for ($i = 0; $i -lt $userEmails.Length; $i++) {
      $splitName = $userNames[$i] -split ' '
      
      $props = @{
        FirstName = $splitName[0]
        LastName = $splitName[1]
        Name = $userNames[$i]
        ExternalEmailAddress = $userEmails[$i]
        Alias = $splitName -join ''
        DisplayName = if ($organisation) {
          "$($userNames[$i]) (EXT $organisation)" 
        } else {
          $userNames[$i]
        }
      }

      try {
          New-MailContact @props
        } catch {
          Write-Host "Failed to add $($userEmails[$i]) $_"
        }
    }
  } else {
    Write-Host "Operation aborted"
  }
}
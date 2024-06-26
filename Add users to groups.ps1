function Add-UsersToGroups {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of email addresses to add. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $users,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Comma separated list of groups to add. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $groups
    )

    $userIds = @()
    $groupIds = @()
    $params = @($users, $groups)

    for ($i = 0; $i -lt $params.Length; $i++) {
        if ($null -ne ($params[$i] | Select-String -Pattern ",")) {
            $arr = $params[$i] -split ','
            $arr = $arr.Trim()
            $params[$i] = $arr
        } 
    } 
     
    foreach ($user in $params[0]) {
        $thisId = (Get-MgUser -Filter "mail eq '$user'").Id
        if (($null -ne $thisId) -and ($thisId -is [string])) {
            $userIds += $thisId
        } else {
            Throw "User `"$user`" not found, operation aborted"
        } 
    }

    foreach ($group in $params[1]) {
        $thisId = (Get-MgGroup -Filter "DisplayName eq '$group'").Id
        if (($null -ne $thisId) -and ($thisId -is [string])) {
            $groupIds += $thisId
        } else {
            Throw "Group `"$group`" not found, operation aborted"
        } 
    }

    foreach ($groupId in $groupIds) {
        foreach ($userId in $userIds) {
            try {
                New-MgGroupMember -GroupId "$groupId" -DirectoryObjectId "$userId" -ErrorAction Stop
            } catch {
                Write-Host "User $userId already exists in Group $groupId"
            }
        }
    }

    Write-Host "Done"
    
}

Connect-MgGraph -Scopes GroupMember.ReadWrite.All, User.Read.All
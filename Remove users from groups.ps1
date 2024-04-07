function Remove-UsersFromGroups {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of email addresses to remove. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $users,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Comma separated list of groups to remove. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        $groups
    )

    $userIds = @()
    $groupIds = @()
    $params = @($users, $groups)

    for ($i = 0; $i -lt $params.Length; $i++) {
        if ($params[$i] | Select-String -Pattern ",") {
            $arr = $params[$i] -split ','
            $arr = $arr.Trim()
        }
        $params[$i] = $arr ? $arr : $params[$i]
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

    foreach ($groupId in $GroupIds) {
        foreach ($userId in $userIds) {
            try {
                Remove-MgGroupMemberByRef -GroupId "$groupId" -DirectoryObjectId "$userId" -ErrorAction Stop
            } catch {
                Write-Host "User $userId does not exist in Group $groupId"
            }
        }
    }

}

Connect-MgGraph -Scopes GroupMember.ReadWrite.All, User.Read.All
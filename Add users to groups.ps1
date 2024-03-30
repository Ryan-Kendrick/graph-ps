function Add-UsersToGroups {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of the users to add")]
        [ValidateNotNullOrEmpty()]
        $users,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Comma separated list of the groups to add")]
        [ValidateNotNullOrEmpty()]
        $groups
    )

    $userIds = @()
    $groupIds = @()
    Write-Host $users.GetType().Name
    Write-Host $groups.GetType().Name
    Write-Host $users
    Write-Host $groups

    # function Change-StringToArray {
    #     param (
    #         $str
    #     )

    # }
    # for ($i = 0; $i -lt 2; $i++) {
    #     $csv = @($users, $groups)[$i]
    #     $csvToArr = @()
    #     if ($csv | Select-String -Pattern ",") {
    #         $csvToArr += $csv -split ','
    #         $csvToArr = $csvToArr.Trim()
    #     }
    # } 


    foreach ($user in $users) {
        $thisId = (Get-MgUser -Filter "mail eq '$user'").Id
        if (($null -ne $thisId) -and ($thisId -is [string])) {
            $userIds += $thisId
        } else {
            Throw "User `"$user`" not found, operation aborted"
        } 
    }

    foreach ($group in $groups) {
        $thisId = (Get-MgGroup -Filter "DisplayName eq '$group'").Id
        if (($null -ne $thisId) -and ($thisId -is [string])) {
            $groupIds += $thisId
        } else {
            Throw "Group `"$group`" not found, operation aborted"
        } 
    }

    Write-Host $userIds
    Write-Host $groupIds

    foreach ($groupId in $GroupIds) {
        foreach ($userId in $userIds) {
            New-MgGroupMember -GroupId "$groupId" -DirectoryObjectId "$userId"
        }
    }

    Write-Host "$userIds"
    Write-Host "$groupIds"

}

Connect-MgGraph -NoWelcome -Scopes GroupMember.ReadWrite.All, User.Read.All
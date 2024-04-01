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
    Write-Host "Users type is $($users.GetType().Name)"
    Write-Host "Groups type is $($groups.GetType().Name)"
    Write-Host "Users state before arrayification is $users"
    Write-Host "Groups state before arrayification is $groups"

 
    $users, $groups = @($users, $groups) | ForEach-Object {
        if ($_ | Select-String -Pattern ",") {
            Write-host "$_"
            $arr = $_ -split ','
            write-host $arr
            $arr = $arr.Trim()
        }
        $arr
    } 
    
    Write-Host "Users state after arrayification is $($users.GetType().Name) $users"
    Write-Host "Groups state after arrayification is $($groups.GetType().Name) $groups"
 

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

    Write-Host "Users after idification is $userIds"
    Write-Host "Groups after idification is $groupIds"

    foreach ($groupId in $GroupIds) {
        foreach ($userId in $userIds) {
            New-MgGroupMember -GroupId "$groupId" -DirectoryObjectId "$userId"
        }
    }

}

Connect-MgGraph -NoWelcome -Scopes GroupMember.ReadWrite.All, User.Read.All

# this script NEEDS to be able to handle group already exists situations - try-catch?
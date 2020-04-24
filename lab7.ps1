<# 
    
    Powershell Lab 
    Manipulate Users, OUs, Groups, and Group Membership
    Date: April 23 2020, Week 13
    Created by: Sharon Jirak 
#>

cls

$menuresponse = "Choose from the following Menu Items: `nA. View one OU `tB. View All OUs `nC. View one group `tD. View All groups `nE. View One user `tF. View All users`n 
`nG. Create one OU `tH. Create one group `nI. Create one user `tJ. Create users from CSV file `n `nK. Add user to group `tL. Remove user from group `n `nM. Delete one group `tN. Delete one user"

$answer = Read-Host $menuresponse


if($answer -eq "A") {

    $ouChoice = Read-Host -Prompt "Which OU to view?"
    Get-ADOrganizationalUnit -filter "Name -eq '$ouChoice'" | format-table -Property Name, DistinguishedName
    pause

}
elseif ($answer -eq "B") {

    $ouChoice = Read-Host -Prompt "Which OU to view?"
    Get-ADOrganizationalUnit -filter "name -ne 'Domain Controllers' " | format-table -Property Name, DistinguishedName
    pause

}
elseif ($answer -eq "C") {

    $groupChoice = Read-Host -Prompt "Which group would you like to see?"
    Get-ADgroup -Filter "name -eq '$groupchoice ' " | select Name, GroupCategory, GroupScope 
    pause

}

elseif ($answer -eq "D") {

    Get-ADgroup -Filter * | select Name, GroupCategory, GroupScope
    pause

}

elseif ($answer -eq "E") {
    $userChoice = Read-Host -Prompt "Which user would you like to see?"
    Get-ADUser -Filter "name -eq '$userChoice ' " | select Name, GroupCategory, GroupScope 
    pause

}

elseif ($answer -eq "F") {
    
    Get-ADUser -Filter * | select Name,Surname, DistinguishedName
    pause

}
elseif ($answer -eq "G") {
    $ouName = Read-Host -Prompt "What would you like the name of your OU to be?"
    New-ADOrganizationalUnit -Name $ouName
    Get-ADOrganizationalUnit -Filter "Name -like '.$ouname'" | Format-Table Name, DistinguishedName
    pause
    
}
elseif ($answer -eq "H") {
    $ouNewGroup = Read-Host -Prompt "What group would you like to create?"
    New-ADGroup -Name $ouNewGroup -GroupScope Global -GroupCategory Security |Format-Table Name, GroupScope, GroupCategory
    Get-ADGroup $ouNewGroup | Format-Table Name, GroupScope, GroupCategory
    pause
}
elseif ($answer -eq "I") {
    $newADUser = Read-Host -Prompt "WHat is the name of the user you would like to create?"
    $answer = Read-Host -Prompt "What is your first name?"
    $answer2 = Read-Host -Prompt "What is your last name?"
    $answer3 = Read-Host -Prompt "What is your street adress?"
    $answer4 = Read-Host -Prompt "What is your city?"
    $answer5 = Read-Host -Prompt "What is your state?"
    $answer6 = Read-Host -Prompt "What is your zipcode?"
    $answer7 = Read-host -Prompt "What is your department"
    $answer8 = Read-Host -Prompt "What company are you in?"
    New-ADUser -Name "$newADuser" -SamAccountName $newADUser -UserPrincipalName "$newAduser@adatum.com" -Surname $answer2 -StreetAddress $answer3 -City $answer4 -State $answer5 -PostalCode $answer6 -Department $answer7 -Company $answer8 -AccountPassword (Read-Host -AsSecureString "Account Password") -PassThru | Enable-ADAccount
    Get-ADUser -Filter * | Format-List Name,SAMAccountName, UserPrincipalName, Surname, StreetAddress , City, State, PostalCode, Company
pause

}
elseif ($answer -eq "J") {
$psw = ConvertTo-SecureString -String "Password01" -AsPlainText -Force
$filepath = Read-Host -Prompt "Please enter the file path to your CSV file"
$users = Import-Csv $filepath
ForEach($user in $users) {
    $fname = $user.'Name'
    $upn = $user.'UserPrincipalName'
    $SAM = $user.'SAMAccountName'
    $city = $user.'City'
    $state = $user.'State'
    $givenName = $user.'GivenName'
    $surname = $user.'Surname'
    $emailAddress = $user.'EmailAddress'
    $company = $user.'Company'
    $department = $user.'Department'
    $division = $user.'Division'

    New-ADUser -Name $fname -UserPrincipalName $upn -SamAccountName $SAM -City $city -State $state -EmailAddress $emailAddress -Company $company -Department $department -Division $divison -AccountPassword $psw

    }
   
}
elseif ($answer -eq "K") {
    $groupForUser = Read-Host -Prompt "What group will gain a user?"
    $userForGroup = Read-Host -Prompt "What user will go into the group"
    Add-ADGroupMember -Identity $groupForUser -Members $userForGroup
    Get-ADGroup -Identity $groupForUser | Format-Table Name,SamAccountName, DistinguishedName
    pause


}
elseif ($answer -eq "L") {
    $groupLoss = Read-Host -Prompt "What group will lose a user?"
    Get-ADGroup -Identity $groupLoss | Format-Table SamAccountName, DistinguishedName
    Get-ADGroupMember -identity $groupLoss -Recursive | Get-ADUser -Property DisplayName | Select SAMAccountName, DistinguishedName
    $removedUser = Read-Host -Prompt "Should one of these users be removed from the group Y or N?"
        if($removedUser -eq 'Y'){
        $nameofuser = Read-Host -Prompt "What user would you like to be removed?"
        Remove-ADGroupMember -Identity $groupLoss -Members $nameofuser 
        } 
        elseif($removedUser -eq 'N'){
        pause
        }


}
elseif ($answer -eq "M") {
    $groupDeletion = Read-Host -Prompt "What is the name of the group you would like to remove?"
    Remove-ADGroup -Identity $groupDeletion
    Get-ADGroup -Filter * | Format-Table Name, GroupScope, GroupCategory
    pause

}
elseif ($answer -eq "N") {

    $userDeletion = Read-Host -Prompt "What user would you like to remove?"
    Remove-ADUser -Identity $userDeletion 
    Get-ADUser -Filter * | Format-Table Name, DistinguishedName
    pause
}

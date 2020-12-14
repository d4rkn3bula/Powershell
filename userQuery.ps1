<#
	.SYNOPSIS
		userQuery.ps1 - Retrieves more relevant data.

    .DESCRIPTION
        This script will take the supplied Active Directory user and display it's field attributes.

    .PARAMETER User
        The user we will be retreiving information about.

    .EXAMPLE
        .\userQuery.ps1 -User USERNAME
        .\userQuery.ps1 USERNAME

    .NOTES
        Author: Kris Rostkowski
#>

# User parameter
Param (
    [parameter(ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$user
    )

# User information retrieval function
function ADInformation($user){
    Import-Module ActiveDirectory
    $count = 0
    While($True){
        Try {
            $userQuery = Get-ADUser -Identity $user -Properties * | sort | select City, Created, Department, Description, EmailAddress, Enabled, gidNumber, HomeDirectory, LastBadPasswordAttempt, LockedOut, Name, Office, PasswordExpired, PasswordLastSet, SID, telephoneNumber, Title, uidNumber
            Write-Output $userQuery
            break
        }
        # Catching null input
        catch [System.Management.Automation.RuntimeException]{
            Write-Output "Please specify a username"
            Write-Output "Example:  .\userQuery -User USERNAME"
            break
        }
        # Catching bad username input
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
            Write-Output "Username doesn't exist"
            break
        }
        # Catching Acitive Directory timeouts
        catch [TimeoutException]{
            Write-Output "Domain timeout, trying again"
            $count++
            if ($count > 3){
                Write-Output "Having issues retrieving information from Active Directory, please try again"
                exit
            }
        }
    }
}

# run function
ADInformation $user
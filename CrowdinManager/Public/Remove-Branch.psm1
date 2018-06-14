<#
.SYNOPSIS
Remove branch from Crowdin.

.PARAMETER ProjectKey
Project API key.

.PARAMETER ProjectId
Should contain the project identifier.

.PARAMETER Branch
Should contain the branch name.

.EXAMPLE
PS C:\> Remove-Branch `
    -ProjectId apitestproject `
    -ProjectKey 87d3...3f58 `
    -Branch 'TestBranch'
#>

function Remove-Branch {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch
    )

    $commonArguments = @{
        ProjectId = $ProjectId
        ProjectKey = $ProjectKey
        Path = $Branch
    }

    Remove-CrowdinDirectory @commonArguments
}

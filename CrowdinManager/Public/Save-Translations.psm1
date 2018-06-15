<#
.SYNOPSIS
Save translations files to Crowdin.

.DESCRIPTION
Dowload translations files to specified directory.

.PARAMETER ProjectKey
Project API key.

.PARAMETER ProjectId
Should contain the project identifier.

.PARAMETER Path
Should contain the directory path where translations files will be downloaded.

.PARAMETER Branch
Should contain the branch name.

.EXAMPLE
PS C:\> Save-Translations `
    -ProjectId apitestproject `
    -ProjectKey 87d3...3f58 `
    -Path C:\Example\Translations_temp
    -Branch 'TestBranch'
#>

function Save-Translations {
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
        [string]$Path,

        [parameter(Mandatory = $false)]
        [string]$Branch
    )

    $commonArguments = @{
        ProjectId = $ProjectId
        ProjectKey = $ProjectKey
    }

    if ($Branch) {
        $commonArguments.Branch = $Branch
    }

    $tempDirectoryPath = "$PSScriptRoot\temp_$([System.Guid]::NewGuid())"
    $tempDirectory = [System.IO.Directory]::CreateDirectory($tempDirectoryPath)

    $translationsZipPath = "$tempDirectoryPath\translations.zip"

    try {
        $buildResult = Export-CrowdinTranslations @commonArguments
        Write-Verbose "Build translations: $($buildResult | Out-String))"

        Save-CrowdinTranslations @commonArguments -FilePath $translationsZipPath
        [System.IO.Compression.ZipFile]::ExtractToDirectory($translationsZipPath, $Path)
    }
    finally {
        if ($tempDirectory.Exists) {
            $tempDirectory.Delete($true)
        }
    }
}

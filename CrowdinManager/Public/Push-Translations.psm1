<#
.SYNOPSIS
Push translations files to Crowdin.

.DESCRIPTION
Branch and the directory should be exist.

.PARAMETER ProjectKey
Project API key.

.PARAMETER ProjectId
Should contain the project identifier.

.PARAMETER SourceRootDirectory
Should contain the directory path where source files are stored.

.PARAMETER FilePathPattern
Should contain the regular expression pattern to match for translation file name.

.PARAMETER CrowdinFilePathTemplate
Should contain the replacement string for file name in Crowdin.

.PARAMETER Language
Should contain the language.

.PARAMETER Branch
Should contain the branch name.

.EXAMPLE
PS C:\> Push-Translations `
    -ProjectId apitestproject `
    -ProjectKey 87d3...3f58 `
    -SourceRootDirectory C:\Example
    -FilePathPattern '(?<rootDirectory>.*)\\en\\(?<filePath>.*\\)?(?<fileName>.*)(\.json$)'
    -CrowdinFilePathTemplate 'MyProject\${filePath}${fileName}.json'
    -Language 'en'
    -Branch 'TestBranch'

Structure of files and directories on the local machine

Example
   └── locales
      ├── ru
      |   ├── folder
      |   |   └── translations.json
      |   ├── translations.json
      |   └── ...
      ├── en
      |   ├── folder
      |   |   └── translations.json
      |   ├── translations.json
      |   └── ...
      └── ...


Structure of files and directories in Crowdin

TestBranch
   └── MyProject
      ├── folder
      |   └── translations.json
      ├── translations.json
      └── ...
#>

function Push-Translations {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$ProjectId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$ProjectKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceRootDirectory,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [regex]$FilePathPattern,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CrowdinFilePathTemplate,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Language,

        [parameter(Mandatory = $false)]
        [string]$Branch,

        [switch]$ImportDuplicates,
        [switch]$ImportEqSuggestions,
        [switch]$AutoApproveImported
    )

    $commonArguments = @{
        ProjectId = $ProjectId
        ProjectKey = $ProjectKey
        Language = $Language
        ImportDuplicates = $ImportDuplicates
        ImportEqSuggestions = $ImportEqSuggestions
        AutoApproveImported = $AutoApproveImported
    }

    if ($Branch) {
        $commonArguments.Branch = $Branch
    }

    $files = Get-ChildItem -Path $SourceRootDirectory -Recurse `
        | Where-Object {$_.FullName -match $FilePathPattern }

    foreach ($file in $files) {
        $filePath = $file.FullName

        $crowdinFilePath = Get-FilePathByTemplate $filePath $FilePathPattern $CrowdinFilePathTemplate

        $arguments = $commonArguments
        $arguments.FilePath = $filePath
        $arguments.CrowdinFilePath = $crowdinFilePath

        $response = Add-CrowdinTranslationFile @arguments

        Write-Verbose "[$($Language)] Push translation file $($filePath) to $($crowdinFilePath). Is Success: $($response.Success)"
    }
}
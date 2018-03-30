<#
.SYNOPSIS
Move translations files from Crowdin archive to project.

.PARAMETER RootDirectory
Should contain the directory path where translations files are stored.

.PARAMETER SourcePattern
Should contain the regular expression pattern to match for translation file name.

.PARAMETER DestTemplate
Should contain the replacement string for translation file name in project.

.EXAMPLE
PS C:\> Move-Translations `
        -RootDirectory 'C:\Example\Translations_temp\en\TestBranch' `
        -SourcePattern '(?<rootDirectory>.*)\\MyProject\\(?<fileName>.*\.json$' `
        -DestTemplate 'C:\Example\MyProject\locales\en\${fileName}'
#>

function Move-Translations {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RootDirectory,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [regex]$SourcePattern,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestTemplate
    )

    $files = Get-ChildItem -Path $RootDirectory -Recurse `
        | Where-Object {$_.FullName -match $SourcePattern }

    foreach ($file in $files) {
        $fullName = $file.FullName

        $filePath = Get-FilePathByTemplate $fullName $SourcePattern $DestTemplate

        Move-Item $fullName $filePath -Force
    }
}
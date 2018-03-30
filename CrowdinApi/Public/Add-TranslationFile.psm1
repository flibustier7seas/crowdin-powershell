function Add-TranslationFile {
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
        [string]$FilePath,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CrowdinFilePath,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Language,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch,

        [switch]$ImportDuplicates,
        [switch]$ImportEqSuggestions,
        [switch]$AutoApproveImported
    )

    $uri = "project/$($ProjectId)/upload-translation?json&key=$($projectKey)&language=$($Language)";
    if ($PSBoundParameters.ContainsKey('Branch'))
    {
        $uri += "&branch=$($Branch)";
    }
    if ($ImportDuplicates) {
        $uri += "&import_duplicates=1"
    }
    if ($ImportEqSuggestions) {
        $uri += "&import_eq_suggestions=1"
    }
    if ($AutoApproveImported) {
        $uri += "&auto_approve_imported=1"
    }

    $arguments = @{
        Uri = $uri
        FilePath = $FilePath
        CrowdinFilePath = $CrowdinFilePath
    }

    Send-CrowdinFile @arguments | ConvertFrom-CrowdinJsonResponse
}
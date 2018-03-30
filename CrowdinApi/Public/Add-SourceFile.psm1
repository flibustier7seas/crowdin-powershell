function Add-SourceFile {
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

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ExportPattern = '%original_file_name%',

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch
    )

    $uri = "project/$($ProjectId)/add-file?json&key=$($projectKey)"
    if ($PSBoundParameters.ContainsKey('Branch'))
    {
        $uri += "&branch=$($Branch)";
    }

    $arguments = @{
        Uri = $uri
        FilePath = $FilePath
        CrowdinFilePath = $CrowdinFilePath
        ExportPattern = $ExportPattern
    }

    Send-CrowdinFile @arguments | ConvertFrom-CrowdinJsonResponse
}
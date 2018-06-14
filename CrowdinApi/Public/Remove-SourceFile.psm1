function Remove-SourceFile {
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
        [string]$CrowdinFilePath,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch
    )

    $uri = "project/$($ProjectId)/delete-file?json&key=$($projectKey)&file=$($CrowdinFilePath)";
    if ($PSBoundParameters.ContainsKey('Branch'))
    {
        $uri += "&branch=$($Branch)";
    }

    Send-CrowdinPostRequest $uri | ConvertFrom-CrowdinJsonResponse
}
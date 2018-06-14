function Remove-Directory {
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

    $uri = "project/$($ProjectId)/delete-directory?json&key=$($ProjectKey)&name=$($Path)";

    if ($PSBoundParameters.ContainsKey('Branch'))
    {
        $uri += "&branch=$($Branch)";
    }

    Send-CrowdinPostRequest $uri | ConvertFrom-CrowdinJsonResponse
}
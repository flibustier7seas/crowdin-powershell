function Export-Translations {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch
    )

    $uri = "project/$($ProjectId)/export?json&key=$($ProjectKey)";
    if ($PSBoundParameters.ContainsKey('Branch'))
    {
        $uri += "&branch=$($Branch)";
    }

    Send-CrowdinGetRequest $uri | ConvertFrom-CrowdinJsonResponse
}
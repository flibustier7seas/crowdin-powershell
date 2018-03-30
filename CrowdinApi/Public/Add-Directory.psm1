function Add-Directory {
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
        [string]$Branch,

        [parameter(Mandatory = $false)]
        [switch]$IsBranch
    )

    $uri = "project/$($ProjectId)/add-directory?json&key=$($ProjectKey)&name=$($Path)";

    if($Branch) {
        $uri += "&branch=$($Branch)";
    }
    if ($IsBranch) {
        $uri += "&is_branch=1"
    }

    Send-CrowdinPostRequest $uri | ConvertFrom-CrowdinJsonResponse
}
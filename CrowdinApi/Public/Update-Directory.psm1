function Update-Directory {
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
        [string]$Name,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NewName,

        [parameter(Mandatory = $false)]
        [string]$Branch
    )

    $uri = "/project/$($ProjectId)/change-directory?json&key=$($ProjectKey)&name=$Name";

    if($Branch) {
        $uri += "&branch=$($Branch)";
    }

    if($NewName -ne $null) {
        $uri += "&new_name=$($NewName)";
    }

    Send-CrowdinPostRequest $uri | ConvertFrom-CrowdinJsonResponse
}
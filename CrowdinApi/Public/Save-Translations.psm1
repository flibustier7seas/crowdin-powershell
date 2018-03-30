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
        [string]$FilePath,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Branch
    )

    $uri = "project/$($ProjectId)/download/all.zip?json&key=$($ProjectKey)";
    if ($PSBoundParameters.ContainsKey('Branch'))
    {
        $uri += "&branch=$($Branch)";
    }

    $response = Send-CrowdinGetRequest $uri

    try {
        $contentStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
        $fileStream = New-Object System.IO.FileStream @($FilePath, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
        $contentStream.CopyTo($fileStream)
    }
    finally {
        if($contentStream -ne $null){
            $contentStream.Dispose();
        }
        if($fileStream -ne $null){
            $fileStream.Dispose();
        }
    }
}
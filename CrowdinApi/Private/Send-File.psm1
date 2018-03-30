function Send-File {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Uri,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CrowdinFilePath,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ExportPattern
    )

    $fileStream = New-Object System.IO.FileStream @($FilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    $streamContent = New-Object System.Net.Http.StreamContent $fileStream

    $fileName = [System.IO.Path]::GetFileName($FilePath)
    $crowdinFileName = $CrowdinFilePath.Replace('\', '/')

    $multipartContent = New-Object System.Net.Http.MultipartFormDataContent
    $multipartContent.Add($streamContent, "`"files[$crowdinFileName]`"", "`"$($fileName)`"")

    if ($PSBoundParameters.ContainsKey('ExportPattern'))
    {
        $stringContent = New-Object System.Net.Http.StringContent $ExportPattern
        $multipartContent.Add($stringContent, "`"export_patterns[$crowdinFileName]`"")
    }

    Send-CrowdinPostRequest $Uri $multipartContent
}

Export-ModuleMember -Function Send-File
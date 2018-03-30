New-Variable ApiBaseUrl -Value ([uri]'https://api.crowdin.com/api/') -Option Constant
New-Variable HttpClient -Value (New-Object System.Net.Http.HttpClient -Property @{BaseAddress = $ApiBaseUrl}) -Option Constant

function Send-GetRequest {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Uri
    )
    try {
        $response = $httpClient.GetAsync($Uri).GetAwaiter().GetResult()

        Write-Debug "Request: $Uri"
        Write-Debug "Status code $($response.StatusCode)"

        return $response
    }
    catch [Exception] {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Send-PostRequest {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Uri]$Uri,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Net.Http.HttpContent]$Content
    )
    try {
        $response = $httpClient.PostAsync($Uri, $Content).GetAwaiter().GetResult()

        Write-Debug "Request: $Uri"
        Write-Debug "Status code $($response.StatusCode)"

        if (Test-CrowdinDebug) {
            $responseBody = $response.Content.ReadAsStringAsync().Result
            Write-Debug "Reason $($response.ReasonPhrase). Server reported the following message:"
            Write-Debug $responseBody
        }

        return $response
    }
    catch [Exception] {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}


Export-ModuleMember -Function Send-GetRequest, Send-PostRequest

$ExecutionContext.SessionState.Module.OnRemove = {
    Clear-Variable -Name HttpClient
}
function  ConvertFrom-JsonResponse {
    PARAM (
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $Response
    )
    process {
        $json = $Response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        ConvertFrom-Json -InputObject $json
    }
}
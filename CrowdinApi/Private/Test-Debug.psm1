function Test-Debug {
    [CmdletBinding()]
    param (
    )
    process {
        ($DebugPreference -ne "SilentlyContinue") -or
        $PSBoundParameters.Debug.IsPresent -or
        $PSDebugContext
    }
}
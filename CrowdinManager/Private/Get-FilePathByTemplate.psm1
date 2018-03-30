function Get-FilePathByTemplate ([string]$FilePath, [regex]$FilePathPattern, [string]$ReplacementTemplate) {
    return [Regex]::Replace($FilePath, $FilePathPattern, $ReplacementTemplate)
}

Export-ModuleMember -Function Get-FilePathByTemplate
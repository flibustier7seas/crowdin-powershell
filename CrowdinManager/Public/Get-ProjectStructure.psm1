<#
.SYNOPSIS
Get Crowdin project structure.

.PARAMETER ProjectKey
Project API key.

.PARAMETER ProjectId
Should contain the project identifier.

.EXAMPLE
PS C:\> Get-ProjectStructure `
    -ProjectId apitestproject `
    -ProjectKey 87d3...3f58 `
#>

function Get-ProjectStructure {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey
    )

    $commonArguments = @{
        ProjectId = $ProjectId
        ProjectKey = $ProjectKey
    }

    [array]$info = Get-CrowdinProjectInfo @commonArguments

    [array]$projectStructure = Get-CrowdinNodes $info.files

    return $projectStructure
}

function Get-CrowdinNodes($files, [string]$rootDirectory = '') {
    $nodes = @()

    foreach ($node in $files) {
        switch ($node.node_type) {
            {@('directory', 'file') -contains $node.node_type} {
                $name = [System.IO.Path]::Combine($rootDirectory, $node.name)
                $nodes += @{
                    name = $name
                    type = $node.node_type
                }
                $nodes += Get-CrowdinNodes $node.files $name
            }
            'branch' {
                [array]$files = Get-CrowdinNodes $node.files
                $nodes += @{
                    name = $node.name
                    type = $node.node_type
                    files = $files
                }
            }
            default {
                throw "Unknow node_type: $($node.node_type)"
            }
        }
    }

    return $nodes
}

function Get-BranchNode($ProjectStructure, [string]$Branch) {
    if($ProjectStructure) {
        $branchNode = $ProjectStructure.GetEnumerator() `
            | Where-Object {$_.name -eq $Branch -and $_.type -eq 'branch' } `
            | Select-Object -First 1

        return $branchNode
    }
}

function Test-ItemExists($Nodes, [string]$Path, [string]$Type) {
    if($Nodes -eq $null){
        return $false
    }

    foreach ($item in ($Nodes.GetEnumerator() | Where-Object {$_.name -eq $Path -and $_.type -eq $Type})) {
        return $true
    }
    return $false
}

Export-ModuleMember -Function Get-ProjectStructure, Get-BranchNode, Test-ItemExists
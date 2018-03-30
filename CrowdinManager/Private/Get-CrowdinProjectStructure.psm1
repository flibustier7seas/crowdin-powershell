function Get-CrowdinProjectStructure($info) {
    return Get-CrowdinNodes $info.files
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
                $nodes += @{
                    name = $node.name
                    type = $node.node_type
                    files = , (Get-CrowdinNodes $node.files)
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

Export-ModuleMember -Function Get-CrowdinProjectStructure, Get-BranchNode, Test-ItemExists
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

Export-ModuleMember -Function Get-CrowdinNodes
Import-module $PSScriptRoot\..\Get-ProjectStructure.psm1 -Force
Import-module $PSScriptRoot\..\..\Private\Get-CrowdinNodes.psm1 -Force


$json = '
{
    "files": [
        {
            "node_type": "branch",
            "name": "Test_Branch",
            "files": [
                {
                    "node_type": "directory",
                    "name": "Example1",
                    "files": []
                }
            ]
        },
        {
            "node_type": "directory",
            "name": "MyProject",
            "files": [
                {
                    "node_type": "directory",
                    "name": "Folder1",
                    "files": [
                        {
                            "node_type": "directory",
                            "name": "Folder11",
                            "files": [
                                {
                                    "node_type": "file",
                                    "name": "translations.json"
                                }
                            ]
                        },
                        {
                            "node_type": "file",
                            "name": "translations.json"
                        }
                    ]
                }
            ]
        }
    ]
}
'

Describe 'Get-CrowdinNodes' {

    $info = ConvertFrom-Json -InputObject $json
    $projectStructure = Get-CrowdinNodes $info.files

    Context 'Get-BranchNode' {

        It "Given valid -Branch '<Branch>', it returns '<Expected>'" -TestCases @(
            @{ Branch = 'Test_Branch'; Expected = $true }
        ) {
            param ($Branch, $Expected)

            $result = Get-BranchNode $projectStructure $Branch

            $result | Should -Be $Expected
        }
    }

    Context 'Test-ItemExists' {

        It "Given valid -Path '<Path>' -Type '<Type>', it returns '<Expected>'" -TestCases @(
            @{ Path = 'MyProject'; Type = 'directory'; Expected = $true },
            @{ Path = 'MyProject\Folder1'; Type = 'directory'; Expected = $true },
            @{ Path = 'MyProject\Folder1\translations.json'; Type = 'file'; Expected = $true },
            @{ Path = 'MyProject\Folder1\Folder11\translations.json'; Type = 'file'; Expected = $true }
            @{ Path = 'Example1'; Type = 'directory'; Branch = 'Test_Branch'; Expected = $true }
        ) {
            param ($Path, $Type, $Branch = '', $Expected)

            $nodes = $projectStructure
            if($Branch) {
                $branchNode = Get-BranchNode $projectStructure $Branch
                $nodes = $branchNode.files
            }

            $result = Test-ItemExists $nodes $Path $Type

            $result | Should -Be $Expected
        }
    }
}

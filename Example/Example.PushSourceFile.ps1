Import-module "$PSScriptRoot\..\CrowdinManager\CrowdinManager.psd1" -Force

$projectId = 'ProjectId'
$projectKey = 'ProjectKey'
$branch = 'TestBranch'

$sourceRootDirectory = "$PSScriptRoot\MyProject"
$sourceFilePathPattern = '(?<rootDirectory>.*)\\ru\\(?<filePath>.*\\)?(?<fileName>.*)(\.json$)'
$crowdinFilePathTemplate = 'MyProject\${filePath}${fileName}.json'

$arguments = @{
    ProjectId = $projectId
    ProjectKey = $projectKey
    SourceRootDirectory = $sourceRootDirectory
    FilePathPattern = $sourceFilePathPattern
    CrowdinFilePathTemplate = $crowdinFilePathTemplate
}

if ($branch) {
    $arguments += @{ Branch = $branch }
}

$DebugPreference = 'Continue'

Push-SourceFiles @arguments -Verbose -Debug

$DebugPreference = 'SilentlyContinue'
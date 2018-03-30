Import-module "$PSScriptRoot\..\CrowdinManager\CrowdinManager.psd1" -Force

$projectId = 'ProjectId'
$projectKey = 'ProjectKey'
$branch = 'TestBranch'

$locales = @(
    @{
        folder = 'en'
        lang = 'en'
    },
    @{
        folder = 'cs'
        lang = 'cs'
    },
    @{
        folder = 'es'
        lang = 'es-CL'
    }
)

$sourceRootDirectory = "$PSScriptRoot\MyProject"
$crowdinFilePathTemplate = 'MyProject\${filePath}${fileName}.json'

$arguments = @{
    ProjectId = $projectId
    ProjectKey = $projectKey
    SourceRootDirectory = $sourceRootDirectory
    CrowdinFilePathTemplate = $crowdinFilePathTemplate
    AutoApproveImported = $true
    ImportDuplicates = $true
    ImportEqSuggestions = $true
}

if ($branch) {
    $arguments += @{ Branch = $branch }
}

$DebugPreference = 'Continue'

foreach ($locale in $locales) {

    $translationFilePathPattern = "(?<rootDirectory>.*)\\(?<lcid>$($locale.folder))\\(?<filePath>.*\\)?(?<fileName>.*)(\.json$)"

    Push-Translations @arguments `
        -FilePathPattern $translationFilePathPattern `
        -Language "$($locale.lang)" `
        -Verbose -Debug
}

$DebugPreference = 'SilentlyContinue'
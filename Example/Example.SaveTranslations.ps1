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
$tempDirectoryPath = "$PSScriptRoot\temp_$([System.Guid]::NewGuid())"

$arguments = @{
    ProjectId = $projectId
    ProjectKey = $projectKey
    Path = $tempDirectoryPath
}
if ($branch) {
    $arguments += @{ Branch = $branch }
}

Save-Translations @arguments -Verbose -Debug

foreach ($locale in $locales) {

    $translationsRootDirectory = [System.IO.Path]::Combine($tempDirectoryPath, $locale.lang)
    $translationsFilePathPattern = "(?<rootDirectory>.*)\\MyProject\\(?<fileName>.*\.json$)"
    $sourceFilePathTemplate = [System.IO.Path]::Combine($sourceRootDirectory, 'locales', $locale.folder, '${fileName}')

    Move-Translations `
        -RootDirectory $translationsRootDirectory `
        -SourcePattern $translationsFilePathPattern `
        -DestTemplate $sourceFilePathTemplate
}


if ([System.IO.Directory]::Exists($tempDirectoryPath)) {
    [System.IO.Directory]::Delete($tempDirectoryPath, $true)
}
# Crowdin manager

Structure of files and directories on the local machine

```
Example
   └── locales
      ├── ru
      |   ├── folder
      |   |   └── translations.json
      |   ├── translations.json
      |   └── ...
      ├── en
      |   ├── folder
      |   |   └── translations.json
      |   ├── translations.json
      |   └── ...
      └── ...
```

Structure of files and directories in Crowdin

```
TestBranch
   └── MyProject
      ├── folder
      |   └── translations.json
      ├── translations.json
      └── ...
```

## Push source file

```ps
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

Push-SourceFiles @arguments -Verbose -Debug
```

## Push translations


```ps
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

foreach ($locale in $locales) {

    $translationFilePathPattern = "(?<rootDirectory>.*)\\(?<lcid>$($locale.folder))\\(?<filePath>.*\\)?(?<fileName>.*)(\.json$)"

    Push-Translations @arguments `
        -FilePathPattern $translationFilePathPattern `
        -Language "$($locale.lang)" `
        -Verbose -Debug
}

```

## Save translations

```ps
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
```
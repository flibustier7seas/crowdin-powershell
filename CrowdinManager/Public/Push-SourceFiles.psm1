<#
.SYNOPSIS
Push source files to Crowdin.

.DESCRIPTION
Create or update source files. If need create branch and directories.

.PARAMETER ProjectKey
Project API key.

.PARAMETER ProjectId
Should contain the project identifier.

.PARAMETER SourceRootDirectory
Should contain the directory path where source files are stored.

.PARAMETER FilePathPattern
Should contain the regular expression pattern to match for source file name.

.PARAMETER CrowdinFilePathTemplate
Should contain the replacement string for file name in Crowdin.

.PARAMETER Branch
Should contain the branch name.

.EXAMPLE
PS C:\> Push-SourceFiles `
    -ProjectId apitestproject `
    -ProjectKey 87d3...3f58 `
    -SourceRootDirectory C:\Example
    -FilePathPattern '(?<rootDirectory>.*)\\ru\\(?<filePath>.*\\)?(?<fileName>.*)(\.json$)'
    -CrowdinFilePathTemplate 'MyProject\${filePath}${fileName}.json'
    -Branch 'TestBranch'

Structure of files and directories on the local machine

Example1
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


Structure of files and directories in Crowdin

TestBranch
   └── MyProject
      ├── folder
      |   └── translations.json
      ├── translations.json
      └── ...
#>

function Push-SourceFiles {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceRootDirectory,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [regex]$FilePathPattern,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CrowdinFilePathTemplate,

        [parameter(Mandatory = $false)]
        [string]$Branch
    )

    $commonArguments = @{
        ProjectId = $ProjectId
        ProjectKey = $ProjectKey
    }

    [array]$projectStructure = Get-ProjectStructure $ProjectId $ProjectKey

    $nodes = $projectStructure
    if ($Branch) {
        $commonArguments.Branch = $Branch

        $branchNode = Get-BranchNode $projectStructure $Branch
        if ($branchNode) {
            $nodes = $branchNode.files
        }
        else {
            Add-NewBranch $ProjectId $ProjectKey $Branch
            $nodes = @()
        }
    }

    [array]$files = Get-ChildItem -Path $SourceRootDirectory -Recurse `
        | Where-Object {$_.FullName -match $FilePathPattern}

    foreach ($file in $files) {
        $filePath = $file.FullName
        $crowdinFilePath = Get-FilePathByTemplate $filePath $FilePathPattern $CrowdinFilePathTemplate

        $addFileArguments = $commonArguments
        $addFileArguments.FilePath = $filePath
        $addFileArguments.CrowdinFilePath = $crowdinFilePath

        $directoryPath = [System.IO.Path]::GetDirectoryName($crowdinFilePath)
        $nodes += Add-DirectoriesIfNeed $ProjectId $ProjectKey $DirectoryPath $Branch $nodes

        $isFileExists = Test-ItemExists $nodes $crowdinFilePath 'file'
        if ($isFileExists) {
            $response = Update-CrowdinSourceFile @addFileArguments
        }
        else {
            $response = Add-CrowdinSourceFile @addFileArguments
        }

        Write-Verbose "Push file $($filePath) to $($crowdinFilePath). Is Success: $($response.Success)"
    }
}

function Add-NewBranch([string]$ProjectId, [string]$ProjectKey, [string]$Branch) {
    $createBranchArgs = @{
        ProjectId = $ProjectId
        ProjectKey = $ProjectKey
        Path = $Branch
        IsBranch = $true
    }

    $response = Add-CrowdinDirectory @createBranchArgs
    Write-Verbose "Add branch $Branch. Is Success: $($response.Success)"
}

function Add-DirectoriesIfNeed([string]$ProjectId, [string]$ProjectKey, [string]$DirectoryPath, [string]$Branch, $ProjectStructure) {
    $isDirectoryExists = Test-ItemExists $ProjectStructure $DirectoryPath 'directory'
    if ($isDirectoryExists -eq $true) {
        return @()
    }
    return Add-SubDirectories $ProjectId $ProjectKey $DirectoryPath $Branch $ProjectStructure
}

function Add-SubDirectories([string]$ProjectId, [string]$ProjectKey, [string]$DirectoryPath, [string]$Branch, $ProjectStructure) {
    $pathSeparators = [System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar

    $pathSegments = $DirectoryPath.Split($pathSeparators)

    $currentPath = ''
    $newDirectories = New-Object System.Collections.ArrayList
    foreach ($segment in $pathSegments) {
        if ($currentPath.Length -ne 0) {
            $currentPath += '\' + $segment
        }
        else {
            $currentPath = $segment
        }

        $isDirectoryExists = Test-ItemExists $ProjectStructure $currentPath 'directory'
        if ($isDirectoryExists -eq $false) {
            $response = Add-CrowdinDirectory $ProjectId $ProjectKey $currentPath $Branch
            $newDirectories.Add(
                @{
                    name = $currentPath
                    type = 'directory'
                })
            Write-Verbose "Add directory $($DirectoryPath). Is Success: $($response.Success)"
        }
    }

    return $newDirectories
}

Export-ModuleMember -Function Push-SourceFiles
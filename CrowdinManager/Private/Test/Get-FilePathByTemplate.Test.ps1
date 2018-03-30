Import-module $PSScriptRoot\..\Get-FilePathByTemplate.psm1 -Force

$Cases = @(
    @{
        FilePath = 'C:\Project\Localization\Resources.en-US.resx'
        FilePathPattern = 'C:\\Project\\(?<filePath>.*)\\((?<fileName>[^\W]*)\.(?<lcid>.*)\.resx$)'
        ReplacementTemplate = '${filePath}\${fileName}.resx'
        Expected = 'Localization\Resources.resx'
    },
    @{
        FilePath = 'C:\Project\Localization\en-US\Resources.resx'
        FilePathPattern = 'C:\\Project\\(?<filePath>.*)\\en-US\\(?<fileName>[^\W]*)\.resx$'
        ReplacementTemplate = '${filePath}\${fileName}.resx'
        Expected = 'Localization\Resources.resx'
    }
)

Describe 'Get-FilePathByTemplate' {
    It "Should return expected result" -TestCases $Cases {
        param ($FilePath, $FilePathPattern, $ReplacementTemplate, $Expected)

        $result = Get-FilePathByTemplate `
            -FilePath $FilePath `
            -FilePathPattern $FilePathPattern `
            -ReplacementTemplate $ReplacementTemplate

        $result | Should -Be $Expected
    }
}
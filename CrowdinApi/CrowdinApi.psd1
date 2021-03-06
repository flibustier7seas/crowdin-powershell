#
# Манифест модуля для модуля "CrowdinApi".
#
# Создано: flibustier7seas
#
# Дата создания: 25.12.2017
#

@{

# Файл модуля сценария или двоичного модуля, связанный с этим манифестом.
RootModule = '.\CrowdinApi.psm1'

# Номер версии данного модуля.
ModuleVersion = '0.0.1'

# Уникальный идентификатор данного модуля
GUID = '2a5eaccc-3c16-4123-8a79-5be125c635db'

# Автор данного модуля
Author = 'flibustier7seas'

# Компания, создавшая данный модуль, или его поставщик
CompanyName = 'Неизвестно'

# Заявление об авторских правах на модуль
Copyright = '(c) 2017 flibustier7seas. Все права защищены.'

# Описание функций данного модуля
# Description = ''

# Минимальный номер версии обработчика Windows PowerShell, необходимой для работы данного модуля
PowerShellVersion = '4.0'

# Имя узла Windows PowerShell, необходимого для работы данного модуля
# PowerShellHostName = ''

# Минимальный номер версии узла Windows PowerShell, необходимой для работы данного модуля
# PowerShellHostVersion = ''

# Минимальный номер версии Microsoft .NET Framework, необходимой для данного модуля
# DotNetFrameworkVersion = ''

# Минимальный номер версии среды CLR (общеязыковой среды выполнения), необходимой для работы данного модуля
# CLRVersion = ''

# Архитектура процессора (нет, X86, AMD64), необходимая для этого модуля
# ProcessorArchitecture = ''

# Модули, которые необходимо импортировать в глобальную среду перед импортированием данного модуля
# RequiredModules = @()

# Сборки, которые должны быть загружены перед импортированием данного модуля
RequiredAssemblies = @('System.Net.Http')

# Файлы сценария (PS1), которые запускаются в среде вызывающей стороны перед импортом данного модуля.
# ScriptsToProcess = @()

# Файлы типа (.ps1xml), которые загружаются при импорте данного модуля
# TypesToProcess = @()

# Файлы формата (PS1XML-файлы), которые загружаются при импорте данного модуля
# FormatsToProcess = @()

# Модули для импорта в качестве вложенных модулей модуля, указанного в параметре RootModule/ModuleToProcess
 NestedModules = @(
     '.\Public\Add-Directory.psm1'
     '.\Public\Update-Directory.psm1'
     '.\Public\Remove-Directory.psm1'

     '.\Public\Add-SourceFile.psm1'
     '.\Public\Update-SourceFile.psm1'
     '.\Public\Remove-SourceFile.psm1'

     '.\Public\Add-TranslationFile.psm1'
     '.\Public\Save-Translations.psm1'
     '.\Public\Export-Translations.psm1'

     '.\Public\Get-ProjectInfo.psm1'
 )

# Функции для экспорта из данного модуля
FunctionsToExport = '*'

# Командлеты для экспорта из данного модуля
CmdletsToExport = '*'

# Переменные для экспорта из данного модуля
VariablesToExport = '*'

# Псевдонимы для экспорта из данного модуля
AliasesToExport = '*'

# Список всех модулей, входящих в пакет данного модуля
# ModuleList = @()

# Список всех файлов, входящих в пакет данного модуля
# FileList = @()

# Личные данные для передачи в модуль, указанный в параметре RootModule/ModuleToProcess
# PrivateData = ''

# Код URI для HelpInfo данного модуля
# HelpInfoURI = ''

# Префикс по умолчанию для команд, экспортированных из этого модуля. Переопределите префикс по умолчанию с помощью команды Import-Module -Prefix.
DefaultCommandPrefix = 'Crowdin'

}


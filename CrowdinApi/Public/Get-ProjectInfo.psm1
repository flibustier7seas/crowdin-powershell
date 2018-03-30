<#
.SYNOPSIS
Get Crowdin Project details.

.DESCRIPTION
Get details, files and languages of Crowdin Project.

.PARAMETER ProjectKey
Project API key.

.PARAMETER ProjectId
Should contain the project identifier.

.EXAMPLE
PS C:\> Get-ProjectInfo -ProjectId apitestproject  -ProjectKey 87d3...3f58 | Select-Object -ExpandProperty details

source_language         : @{name=English; code=en}
name                    : ApiTestProject
identifier              : apitestproject
created                 : 2017-10-29T20:44:43+0000
description             :
join_policy             : private
last_build              : 2017-11-12T18:24:46+0000
last_activity           : 2017-10-29T20:44:43+0000
participants_count      : 1
logo_url                :
total_strings_count     : 0
total_words_count       :
duplicate_strings_count : 0
duplicate_words_count   : 0
invite_url              : @{translator=https://crowdin.com/project/apitestproject/invite?d=55b...353; proofreader=https://crowdin.com/project/apitestproject/invite?d=15b...353}

#>

function Get-ProjectInfo {
    [CmdletBinding()]
    PARAM
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectId,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectKey
    )

    $uri = "project/$($ProjectId)/info?json&key=$ProjectKey"

    Send-CrowdinPostRequest $uri | ConvertFrom-CrowdinJsonResponse
}
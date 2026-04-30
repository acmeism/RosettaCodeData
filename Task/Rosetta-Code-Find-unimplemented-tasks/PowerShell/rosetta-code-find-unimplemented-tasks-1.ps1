function Find-UnimplementedTask
{
    [CmdletBinding()]
    [OutputType([string[]])]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]
        $Language
    )

    $url = "http://rosettacode.org/wiki/Reports:Tasks_not_implemented_in_$Language"
    $web = Invoke-WebRequest $url
    $unimplemented = 1

    [string[]](($web.AllElements |
        Where-Object {$_.class -eq "mw-content-ltr"})[$unimplemented].outerText -split "`r`n" |
        Select-String -Pattern "[^0-9A-Z]$" -CaseSensitive)
}

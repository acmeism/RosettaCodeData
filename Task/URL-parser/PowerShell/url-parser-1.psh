function Get-ParsedUrl
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [System.Uri]
        $InputObject
    )

    Process
    {
        foreach ($url in $InputObject)
        {
            $url | Select-Object -Property Scheme,
                                           @{Name="Domain"; Expression={$_.Host}},
                                           Port,
                                           @{Name="Path"  ; Expression={$_.LocalPath}},
                                           Query,
                                           Fragment,
                                           AbsolutePath,
                                           AbsoluteUri,
                                           Authority,
                                           HostNameType,
                                           IsDefaultPort,
                                           IsFile,
                                           IsLoopback,
                                           PathAndQuery,
                                           Segments,
                                           IsUnc,
                                           OriginalString,
                                           DnsSafeHost,
                                           IdnHost,
                                           IsAbsoluteUri,
                                           UserEscaped,
                                           UserInfo
        }
    }
}

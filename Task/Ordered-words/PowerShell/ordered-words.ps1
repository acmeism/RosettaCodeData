$url = 'http://www.puzzlers.org/pub/wordlists/unixdict.txt'

(New-Object System.Net.WebClient).DownloadFile($url, "$env:TEMP\unixdict.txt")

$ordered = Get-Content -Path "$env:TEMP\unixdict.txt" |
    ForEach-Object {if (($_.ToCharArray() | Sort-Object) -join '' -eq $_) {$_}} |
    Group-Object  -Property Length |
    Sort-Object   -Property Name |
    Select-Object -Property @{Name="WordCount" ; Expression={$_.Count}},
                            @{Name="WordLength"; Expression={[int]$_.Name}},
                            @{Name="Words"     ; Expression={$_.Group}} -Last 1

"There are {0} ordered words of the longest word length ({1} characters):`n`n{2}" -f $ordered.WordCount,
                                                                                     $ordered.WordLength,
                                                                                    ($ordered.Words -join ", ")
Remove-Item -Path "$env:TEMP\unixdict.txt" -Force -ErrorAction SilentlyContinue

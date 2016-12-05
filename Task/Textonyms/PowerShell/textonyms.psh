$url  = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"
$file = "$env:TEMP\unixdict.txt"
(New-Object System.Net.WebClient).DownloadFile($url, $file)
$unixdict = Get-Content -Path $file

[string]$alpha = "abcdefghijklmnopqrstuvwxyz"
[string]$digit = "22233344455566677778889999"

$table = [ordered]@{}

for ($i = 0; $i -lt $alpha.Length; $i++)
{
    $table.Add($alpha[$i], $digit[$i])
}

$words = foreach ($word in $unixdict)
{
    if ($word -match "^[a-z]*$")
    {
        [PSCustomObject]@{
            Word   = $word
            Number = ($word.ToCharArray() | ForEach-Object {$table.$_}) -join ""
        }
    }
}

$digitCombinations = $words | Group-Object -Property Number

$textonyms = $digitCombinations | Where-Object -Property Count -GT 1 | Sort-Object -Property Count -Descending

Write-Host ("There are {0} words in {1} which can be represented by the digit key mapping." -f $words.Count, $url)
Write-Host ("They require {0} digit combinations to represent them."                        -f $digitCombinations.Count)
Write-Host ("{0} digit combinations represent Textonyms.`n"                                 -f $textonyms.Count)

Write-Host "Top 5 in ambiguity:"
$textonyms | Select-Object -First 5 -Property Count,
                                              @{Name="Textonym"; Expression={$_.Name}},
                                              @{Name="Words"   ; Expression={$_.Group.Word -join ", "}} | Format-Table -AutoSize
Write-Host "Top 5 in length:"
$textonyms | Sort-Object {$_.Name.Length} -Descending |
             Select-Object -First 5 -Property @{Name="Length"  ; Expression={$_.Name.Length}},
                                              @{Name="Textonym"; Expression={$_.Name}},
                                              @{Name="Words"   ; Expression={$_.Group.Word -join ", "}} | Format-Table -AutoSize

Remove-Item -Path $file -Force -ErrorAction SilentlyContinue

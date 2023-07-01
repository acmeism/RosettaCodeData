function Test-Deranged ([string[]]$Strings)
{
    $array1 = $Strings[0].ToCharArray()

    for ($i = 1; $i -lt $Strings.Count; $i++)
    {
        $array2 = $Strings[$i].ToCharArray()

        for ($i = 0; $i -lt $array1.Count; $i++)
        {
            if ($array1[$i] -match $array2[$i])
            {
                return $false
            }
        }
    }

    return $true
}


$words = [System.Collections.ArrayList]@()

Get-Content -Path ".\unixdict.txt" |
    ForEach-Object { [void]$words.Add([PSCustomObject]@{Word=$_; SortedWord=(($_.ToCharArray() | Sort-Object) -join "")}) }

[object[]]$anagrams = $words | Group-Object -Property SortedWord | Where-Object -Property Count -GT 1 | Sort-Object {$_.Name.Length}
[string[]]$deranged = ($anagrams | ForEach-Object { if ((Test-Deranged $_.Group.Word)) {$_} } | Select-Object -Last 1).Group.Word

[PSCustomObject]@{
    Length = $deranged[0].Length
    Words  = $deranged
}

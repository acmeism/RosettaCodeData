# script Soundex.ps1
Param([string]$Phrase)
Process {
    $src = $Phrase.ToUpper().Trim()
    $coded = $src[0..($src.Length - 1)] | %{
        if('BFPV'.Contains($_)) { '1' }
        elseif('CGJKQSXZ'.Contains($_)) { '2' }
        elseif('DT'.Contains($_)) { '3' }
        elseif('L'.Contains($_)) { '4' }
        elseif('MN'.Contains($_)) { '5' }
        elseif('R'.Contains($_)) { '6' }
        elseif('AEIOU'.Contains($_)) { 'v' }
        else { '.' }
    } | Where { $_ -ne '.'}
    $coded2 = 0..($coded.Length - 1) | %{ if ($_ -eq 0 -or $coded[$_] -ne $coded[$_ - 1]) { $coded[$_] } else { '' } }
    $coded2 = if ($coded[0] -eq 'v' -or $coded2[0] -ne $coded[0]) { $coded2 } else { $coded2[1..($coded2.Length - 1)] }
    $src[0] + ((-join $($coded2 | Where { $_ -ne 'v'})) + "000").Substring(0,3)
}

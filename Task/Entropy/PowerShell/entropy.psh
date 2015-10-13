function entropy ($string) {
    $n = $string.Length
    $string.ToCharArray() | group | foreach{
        $p = $_.Count/$n
        $i = [Math]::Log($p,2)
        -$p*$i
    } | measure -Sum | foreach Sum
}
entropy "1223334444"

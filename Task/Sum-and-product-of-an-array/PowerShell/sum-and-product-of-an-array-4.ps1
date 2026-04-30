function Get-SumAndProduct ($a) {
    $sum = 0
    if ($a.Length -eq 0) {
        $prod = 0
    } else {
        $prod = 1
        foreach ($x in $a) {
            $sum += $x
            $prod *= $x
        }
    }
    $ret = New-Object PSObject
    $ret | Add-Member NoteProperty Sum $sum
    $ret | Add-Member NoteProperty Product $prod
    return $ret
}

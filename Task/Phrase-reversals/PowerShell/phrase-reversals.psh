function reverse($a, $sep = "") {
    if($a.Length -gt 0) {
        $a = $a[($a.Length -1)..0] -join $sep
    }
    $a
}
$line = "rosetta code phrase reversal"
$task1 = reverse $line
$task2 = ($line -split " " | foreach{ reverse $_  }) -join " "
$task3 = reverse ($line -split " ") " "
$task1
$task2
$task3

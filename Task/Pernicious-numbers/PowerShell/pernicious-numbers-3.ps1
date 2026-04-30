$start, $end = 0, 999999
$range1 = $start..$end | Select-PerniciousNumber | Select-Object -First 25

"First {0} pernicious numbers:`n{1}`n" -f $range1.Count, ($range1 -join ", ")

$start, $end = 888888877, 888888888
$range2 = $start..$end | Select-PerniciousNumber

"Pernicious numbers between {0} and {1}:`n{2}`n" -f $start, $end, ($range2 -join ", ")

$ackermann = 0..3 | ForEach-Object {$m = $_; 0..6 | ForEach-Object {Get-Ackermann $m  $_}}

$ackermann | Format-Wide {"{0,3}" -f $_} -Column 7 -Force

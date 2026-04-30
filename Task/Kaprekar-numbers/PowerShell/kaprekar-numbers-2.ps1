"Kaprekar numbers less than 10,000:"
1..10000 | ForEach-Object {if (Test-Kaprekar -Number $_) {"{0,6}" -f $_}} | Format-Wide {$_} -Column 17 -Force

"Kaprekar numbers less than 1,000,000:"
1..1000000 | ForEach-Object {if (Test-Kaprekar -Number $_) {"{0,6}" -f $_}} | Format-Wide {$_} -Column 18 -Force

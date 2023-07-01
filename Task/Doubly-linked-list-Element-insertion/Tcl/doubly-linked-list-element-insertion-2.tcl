set B [List new 3]
set A [List new 1 $B]
set C [List new 2]
$A insertAfter $C
puts [format "{%d,%d,%d}" [$A value] [[$A next] value] [[[$A next] next] value]]

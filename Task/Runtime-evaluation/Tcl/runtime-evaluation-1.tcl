set four 4
set result1 [eval "expr {$four + 5}"]           ;# string input

set result2 [eval [list expr [list $four + 5]]] ;# list input

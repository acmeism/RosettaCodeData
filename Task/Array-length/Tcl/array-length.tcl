;# not recommended:
set mylistA {apple orange}   ;# actually a string
set mylistA "Apple Orange"   ;# same - this works only for simple cases

set lenA [llength $mylistA]
puts "$mylistA :  $lenA"

# better:  to build a list, use 'list' and/or 'lappend':
set mylistB [list apple orange "red wine" {green frog}]
lappend mylistB "blue bird"

set lenB [llength $mylistB]
puts "$mylistB :  $lenB"

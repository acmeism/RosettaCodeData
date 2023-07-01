set aList {foo}
lappend aList # bar
puts $aList           ;# ==> prints "foo # bar"
puts [llength $aList] ;# ==> 3

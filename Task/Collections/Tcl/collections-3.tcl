# create an empty dictionary
set d [dict create]
dict set d one 1
dict set d two 2
# create another
set e [dict create three 3 four 4]
set f [dict merge $d $e]
dict set f nested [dict create five 5 more [list 6 7 8]]
puts [dict get $f nested more] ;# ==> 6 7 8

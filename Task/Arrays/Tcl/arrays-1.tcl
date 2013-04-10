set ary {}

lappend ary 1
lappend ary 3

lset ary 0 2

puts [lindex $ary 0]

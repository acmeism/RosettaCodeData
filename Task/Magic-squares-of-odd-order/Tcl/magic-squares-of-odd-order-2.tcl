package require Tcl 8.6

set square [magicSquare 5]
puts [join [lmap row $square {join [lmap n $row {format "%2s" $n}]}] "\n"]
puts "magic number = [tcl::mathop::+ {*}[lindex $square 0]]"

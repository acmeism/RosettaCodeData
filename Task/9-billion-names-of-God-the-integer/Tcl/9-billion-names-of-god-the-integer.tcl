set cache 1
proc cumu {n} {
    global cache
    for {set l [llength $cache]} {$l <= $n} {incr l} {
	set r 0
	for {set x 1; set y [expr {$l-1}]} {$y >= 0} {incr x; incr y -1} {
	    lappend r [expr {
		[lindex $r end] + [lindex $cache $y [expr {min($x, $y)}]]
	    }]
	}
	lappend cache $r
    }
    return [lindex $cache $n]
}
proc row {n} {
    set r [cumu $n]
    for {set i 0; set j 1} {$j < [llength $r]} {incr i; incr j} {
	lappend result [expr {[lindex $r $j] - [lindex $r $i]}]
    }
    return $result
}

puts "rows:"
foreach x {1 2 3 4 5 6 7 8 9 10} {
    puts "${x}: \[[join [row $x] {, }]\]"
}
puts "\nsums:"
foreach x {23 123 1234 12345} {
    puts "${x}: [lindex [cumu $x] end]"
}

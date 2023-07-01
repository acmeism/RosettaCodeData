package require Tcl 8.6

proc farey {n} {
    set nums [lrepeat [expr {$n+1}] 1]
    set result {{0 1}}
    for {set found 1} {$found} {} {
	set nj [lindex $nums [set j 1]]
	for {set found 0;set i 1} {$i <= $n} {incr i} {
	    if {[lindex $nums $i]*$j < $nj*$i} {
		set nj [lindex $nums [set j $i]]
		set found 1
	    }
	}
	lappend result [list $nj $j]
	for {set i $j} {$i <= $n} {incr i $j} {
	    lset nums $i [expr {[lindex $nums $i] + 1}]
	}
    }
    return $result
}

for {set i 1} {$i <= 11} {incr i} {
    puts F($i):\x20[lmap n [farey $i] {join $n /}]
}
for {set i 100} {$i <= 1000} {incr i 100} {
    puts |F($i)|\x20=\x20[llength [farey $i]]
}

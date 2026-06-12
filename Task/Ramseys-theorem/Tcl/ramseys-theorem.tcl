package require Tcl 8.6

# Generate the connectivity matrix
set init [split [format -%b 53643] ""]
set matrix {}
for {set r $init} {$r ni $matrix} {set r [concat [lindex $r end] [lrange $r 0 end-1]]} {
    lappend matrix $r
}

# Check that every clique of four has at least *one* pair connected and one
# pair unconnected. ASSUMES that the graph is symmetric.
proc ramseyCheck4 {matrix} {
    set N [llength $matrix]
    set connectivity [lrepeat 6 -]
    for {set a 0} {$a < $N} {incr a} {
	for {set b 0} {$b < $N} {incr b} {
	    if {$a==$b} continue
	    lset connectivity 0 [lindex $matrix $a $b]
	    for {set c 0} {$c < $N} {incr c} {
		if {$a==$c || $b==$c} continue
		lset connectivity 1 [lindex $matrix $a $c]
		lset connectivity 2 [lindex $matrix $b $c]
		for {set d 0} {$d < $N} {incr d} {
		    if {$a==$d || $b==$d || $c==$d} continue
		    lset connectivity 3 [lindex $matrix $a $d]
		    lset connectivity 4 [lindex $matrix $b $d]
		    lset connectivity 5 [lindex $matrix $c $d]

		    # We've extracted a meaningful subgraph; check its connectivity
		    if {0 ni $connectivity} {
			puts "FAIL! Found wholly connected: $a $b $c $d"
			return
		    } elseif {1 ni $connectivity} {
			puts "FAIL! Found wholly unconnected: $a $b $c $d"
			return
		    }
		}
	    }
	}
    }
    puts "Satisfies Ramsey condition"
}

puts [join $matrix \n]
ramseyCheck4 $matrix

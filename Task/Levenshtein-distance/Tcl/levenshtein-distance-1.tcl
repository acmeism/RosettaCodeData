proc levenshteinDistance {s t} {
    # Edge cases
    if {![set n [string length $t]]} {
	return [string length $s]
    } elseif {![set m [string length $s]]} {
	return $n
    }
    # Fastest way to initialize
    for {set i 0} {$i <= $m} {incr i} {
	lappend d 0
	lappend p $i
    }
    # Loop, computing the distance table (well, a moving section)
    for {set j 0} {$j < $n} {} {
	set tj [string index $t $j]
	lset d 0 [incr j]
	for {set i 0} {$i < $m} {} {
	    set a [expr {[lindex $d $i]+1}]
	    set b [expr {[lindex $p $i]+([string index $s $i] ne $tj)}]
	    set c [expr {[lindex $p [incr i]]+1}]
	    # Faster than min($a,$b,$c)
	    lset d $i [expr {$a<$b ? $c<$a ? $c : $a : $c<$b ? $c : $b}]
	}
	# Swap
	set nd $p; set p $d; set d $nd
    }
    # The score is at the end of the last-computed row
    return [lindex $p end]
}

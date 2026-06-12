package require Tcl 8.5

proc montgomeryReduction {m mDash T n {b 2}} {
    set A $T
    for {set i 0} {$i < $n} {incr i} {
	# Could be simplified for cases b==2 and b==10
	for {set j 0;set a $A} {$j < $i} {incr j} {
	    set a [expr {$a / $b}]
	}
	set ui [expr {($a % $b) * $mDash % $b}]
	incr A [expr {$ui * $m * $b**$i}]
    }
    set A [expr {$A / ($b ** $n)}]
    return [expr {$A >= $m ? $A - $m : $A}]
}

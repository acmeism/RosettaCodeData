proc bernoulli {n} {
    for {set m 0} {$m <= $n} {incr m} {
	lappend A [list 1 [expr {$m + 1}]]
	for {set j $m} {[set i $j] >= 1} {} {
	    lassign [lindex $A [incr j -1]] a1 b1
	    lassign [lindex $A $i] a2 b2
	    set x [set p [expr {$i * ($a1*$b2 - $a2*$b1)}]]
	    set y [set q [expr {$b1 * $b2}]]
	    while {$q} {set q [expr {$p % [set p $q]}]}
	    lset A $j [list [expr {$x/$p}] [expr {$y/$p}]]
	}
    }
    return [lindex $A 0]
}

set len 0
for {set n 0} {$n <= 60} {incr n} {
    set b [bernoulli $n]
    if {[lindex $b 0]} {
	lappend result $n {*}$b
	set len [expr {max($len, [string length [lindex $b 0]])}]
    }
}
foreach {n num denom} $result {
    puts [format {B_%-2d = %*lld/%lld} $n $len $num $denom]
}

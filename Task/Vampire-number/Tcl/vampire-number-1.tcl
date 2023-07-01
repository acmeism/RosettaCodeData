proc factorPairs {n {from 2}} {
    set result [list 1 $n]
    if {$from<=1} {set from 2}
    for {set i $from} {$i<=sqrt($n)} {incr i} {
	if {$n%$i} {} {lappend result $i [expr {$n/$i}]}
    }
    return $result
}

proc vampireFactors {n} {
    if {[string length $n]%2} return
    set half [expr {[string length $n]/2}]
    set digits [lsort [split $n ""]]
    set result {}
    foreach {a b} [factorPairs $n [expr {10**$half/10}]] {
	if {
	    [string length $a]==$half && [string length $b]==$half &&
	    ($a%10 || $b%10) && $digits eq [lsort [split $a$b ""]]
	} then {
	    lappend result [list $a $b]
	}
    }
    return $result
}

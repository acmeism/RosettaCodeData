package require Tcl 8.6
package require math::numtheory

proc firstNprimes n {
    for {set result {};set i 2} {[llength $result] < $n} {incr i} {
	if {[::math::numtheory::isprime $i]} {
	    lappend result $i
	}
    }
    return $result
}

proc firstN_KalmostPrimes {n k} {
    set p [firstNprimes $n]
    set i [lrepeat $k 0]
    set c {}

    while true {
	dict set c [::tcl::mathop::* {*}[lmap j $i {lindex $p $j}]] ""
	for {set x 0} {$x < $k} {incr x} {
	    lset i $x [set xx [expr {([lindex $i $x] + 1) % $n}]]
	    if {$xx} break
	}
	if {$x == $k} break
    }
    return [lrange [lsort -integer [dict keys $c]] 0 [expr {$n - 1}]]
}

for {set K 1} {$K <= 5} {incr K} {
    puts "$K => [firstN_KalmostPrimes 10 $K]"
}

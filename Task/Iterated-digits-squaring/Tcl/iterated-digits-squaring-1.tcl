proc ids n {
    while {$n != 1 && $n != 89} {
	set n [tcl::mathop::+ {*}[lmap x [split $n ""] {expr {$x**2}}]]
    }
    return $n
}
for {set i 1} {$i <= 100000000} {incr i} {
    incr count [expr {[ids $i] == 89}]
}
puts $count

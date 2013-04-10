proc constructBalancedString {n} {
    set s ""
    for {set i 0} {$i < $n} {incr i} {
	set x [expr {int(rand() * ([string length $s] + 1))}]
	set s "[string range $s 0 [expr {$x-1}]]\[\][string range $s $x end]"
    }
    return $s
}

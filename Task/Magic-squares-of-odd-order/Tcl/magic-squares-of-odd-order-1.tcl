proc magicSquare {order} {
    if {!($order & 1) || $order < 0} {
	error "order must be odd and positive"
    }
    set s [lrepeat $order [lrepeat $order 0]]
    set x [expr {$order / 2}]
    set y 0
    for {set i 1} {$i <= $order**2} {incr i} {
	lset s $y $x $i
	set x [expr {($x + 1) % $order}]
	set y [expr {($y - 1) % $order}]
	if {[lindex $s $y $x]} {
	    set x [expr {($x - 1) % $order}]
	    set y [expr {($y + 2) % $order}]
	}
    }
    return $s
}

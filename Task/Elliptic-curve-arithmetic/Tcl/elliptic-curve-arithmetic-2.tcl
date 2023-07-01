proc show {s p} {
    if {[iszero $p]} {
	puts "${s}Zero"
    } else {
	dict with p {}
	puts [format "%s(%.3f, %.3f)" $s $x $y]
    }
}
proc fromY y {
    global C
    dict set r x [expr {cuberoot($y**2 - $C)}]
    dict set r y [expr {double($y)}]
}

set a [fromY 1]
set b [fromY 2]
show "a = " $a
show "b = " $b
show "c = a + b = " [set c [add $a $b]]
show "d = -c = " [set d [negate $c]]
show "c + d = " [add $c $d]
show "a + b + d = " [add $a [add $b $d]]
show "a * 12345 = " [multiply $a 12345]

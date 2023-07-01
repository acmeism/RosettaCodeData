proc froots {lambda {start -3} {end 3} {step 0.0001}} {
    set res {}
    set lastsign [sgn [apply $lambda $start]]
    for {set x $start} {$x <= $end} {set x [expr {$x + $step}]} {
        set sign [sgn [apply $lambda $x]]
        if {$sign != $lastsign} {
            lappend res [format ~%.11f $x]
        }
        set lastsign $sign
    }
    return $res
}
proc sgn x {expr {($x>0) - ($x<0)}}

puts [froots {x {expr {$x**3 - 3*$x**2 + 2*$x}}}]

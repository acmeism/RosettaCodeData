proc frootsNR {f df {start -3} {end 3} {step 0.001}} {
    set res {}
    set lastsign [sgn [apply $f $start]]
    for {set x $start} {$x <= $end} {set x [expr {$x + $step}]} {
        set sign [sgn [apply $f $x]]
        if {$sign != $lastsign} {
            lappend res [format ~%.15f [nr $x $f $df]]
        }
        set lastsign $sign
    }
    return $res
}
proc sgn x {expr {($x>0) - ($x<0)}}
proc nr {x1 f df} {
    # Newton's method converges very rapidly indeed
    for {set iters 0} {$iters < 10} {incr iters} {
        set x1 [expr {
            [set x0 $x1] - [apply $f $x0]/[apply $df $x0]
        }]
        if {$x0 == $x1} {
            break
        }
    }
    return $x1
}

puts [frootsNR \
    {x {expr {$x**3 - 3*$x**2 + 2*$x}}} \
    {x {expr {3*$x**2 - 6*$x + 2}}}]

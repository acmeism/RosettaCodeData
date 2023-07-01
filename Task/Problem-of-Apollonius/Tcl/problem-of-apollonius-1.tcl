package require TclOO; # Just so we can make a circle class

oo::class create circle {
    variable X Y Radius
    constructor {x y radius} {
	namespace import ::tcl::mathfunc::double
	set X [double $x]; set Y [double $y]; set Radius [double $radius]
    }
    method values {} {list $X $Y $Radius}
    method format {} {
	format "Circle\[o=(%.2f,%.2f),r=%.2f\]" $X $Y $Radius
    }
}

proc solveApollonius {c1 c2 c3 {s1 1} {s2 1} {s3 1}} {
    if {abs($s1)!=1||abs($s2)!=1||abs($s3)!=1} {
	error "wrong sign; must be 1 or -1"
    }

    lassign [$c1 values] x1 y1 r1
    lassign [$c2 values] x2 y2 r2
    lassign [$c3 values] x3 y3 r3

    set v11 [expr {2*($x2 - $x1)}]
    set v12 [expr {2*($y2 - $y1)}]
    set v13 [expr {$x1**2 - $x2**2 + $y1**2 - $y2**2 - $r1**2 + $r2**2}]
    set v14 [expr {2*($s2*$r2 - $s1*$r1)}]

    set v21 [expr {2*($x3 - $x2)}]
    set v22 [expr {2*($y3 - $y2)}]
    set v23 [expr {$x2**2 - $x3**2 + $y2**2 - $y3**2 - $r2**2 + $r3**2}]
    set v24 [expr {2*($s3*$r3 - $s2*$r2)}]

    set w12 [expr {$v12 / $v11}]
    set w13 [expr {$v13 / $v11}]
    set w14 [expr {$v14 / $v11}]

    set w22 [expr {$v22 / $v21 - $w12}]
    set w23 [expr {$v23 / $v21 - $w13}]
    set w24 [expr {$v24 / $v21 - $w14}]

    set P [expr {-$w23 / $w22}]
    set Q [expr {$w24 / $w22}]
    set M [expr {-$w12 * $P - $w13}]
    set N [expr {$w14 - $w12 * $Q}]

    set a [expr {$N**2 + $Q**2 - 1}]
    set b [expr {2*($M*$N - $N*$x1 + $P*$Q - $Q*$y1 + $s1*$r1)}]
    set c [expr {($x1-$M)**2 + ($y1-$P)**2 - $r1**2}]

    set rs [expr {(-$b - sqrt($b**2 - 4*$a*$c)) / (2*$a)}]
    set xs [expr {$M + $N*$rs}]
    set ys [expr {$P + $Q*$rs}]

    return [circle new $xs $ys $rs]
}

package require Tcl 8.5
package require math::special
package require math::polynomials
package require math::constants
math::constants::constants pi

# Computes the initial guess for the root i of a n-order Legendre polynomial
proc guess {n i} {
    global pi
    expr { cos($pi * ($i - 0.25) / ($n + 0.5)) }
}

# Computes and evaluates the n-order Legendre polynomial at the point x
proc legpoly {n x} {
    math::polynomials::evalPolyn [math::special::legendre $n] $x
}

# Computes and evaluates the derivative of an n-order Legendre polynomial at point x
proc legdiff {n x} {
    expr {$n / ($x**2 - 1) * ($x * [legpoly $n $x] - [legpoly [incr n -1] $x])}
}

# Computes the n nodes for an n-point quadrature rule. (i.e. n roots of a n-order polynomial)
proc nodes n {
    set x [lrepeat $n 0.0]
    for {set i 0} {$i < $n} {incr i} {
	set val [guess $n [expr {$i + 1}]]
	foreach . {1 2 3 4 5} {
	    set val [expr {$val - [legpoly $n $val] / [legdiff $n $val]}]
	}
	lset x $i $val
    }
    return $x
}

# Computes the weight for an n-order polynomial at the point (node) x
proc legwts {n x} {
    expr {2.0 / (1 - $x**2) / [legdiff $n $x]**2}
}

# Takes a array of nodes x and computes an array of corresponding weights w
proc weights x {
    set n [llength $x]
    set w {}
    foreach xi $x {
	lappend w [legwts $n $xi]
    }
    return $w
}

# Integrates a lambda term f with a n-point Gauss-Legendre quadrature rule over the interval [a,b]
proc gausslegendreintegrate {f n a b} {
    set x [nodes $n]
    set w [weights $x]
    set rangesize2 [expr {($b - $a)/2}]
    set rangesum2 [expr {($a + $b)/2}]
    set sum 0.0
    foreach xi $x wi $w {
	set y [expr {$rangesize2*$xi + $rangesum2}]
	set sum [expr {$sum + $wi*[apply $f $y]}]
    }
    expr {$sum * $rangesize2}
}

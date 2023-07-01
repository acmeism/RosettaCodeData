# Exact integer versions
proc tcl::mathfunc::P {n k} {
    set t 1
    for {set i $n} {$i > $n-$k} {incr i -1} {
	set t [expr {$t * $i}]
    }
    return $t
}
proc tcl::mathfunc::C {n k} {
    set t [P $n $k]
    for {set i $k} {$i > 1} {incr i -1} {
	set t [expr {$t / $i}]
    }
    return $t
}

# Floating point versions using the Gamma function
package require math
proc tcl::mathfunc::lnGamma n {math::ln_Gamma $n}
proc tcl::mathfunc::fP {n k} {
    expr {exp(lnGamma($n+1) - lnGamma($n-$k+1))}
}
proc tcl::mathfunc::fC {n k} {
    expr {exp(lnGamma($n+1) - lnGamma($n-$k+1) - lnGamma($k+1))}
}

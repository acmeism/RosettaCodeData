namespace eval longfloat {
    proc + {num args} {
	set num [impl::Tidy $num]
	foreach x $args {
	    set num [impl::Add $num [impl::Tidy $x]]
	}
	return [impl::Normalize $num]
    }
    proc * {num args} {
	set num [impl::Tidy $num]
	foreach x $args {
	    set num [impl::Mul $num [impl::Tidy $x]]
	}
	return [impl::Normalize $num]
    }

    namespace export + *

    # This namespace contains the implementations of the operations and
    # isn't intended to be called directly by the rest of the program.
    namespace eval impl {
	variable FloatRE \
		{(?i)^([-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+))(?:e([-+]?[0-9]+))?$}

	proc Tidy {n} {
	    variable FloatRE
	    # Parse the input
	    if {[llength $n] == 2} {
		return $n
	    } elseif {[llength $n] != 1} {
		return -level 2 -code error "non-numeric argument"
	    } elseif {![regexp $FloatRE $n -> mantissa exponent]} {
		return -level 2 -code error "non-numeric argument"
	    }

	    # Default exponent is zero
	    if {$exponent eq ""} {
		set exponent 0
	    }
	    # Eliminate the decimal point
	    set bits [split $mantissa .]
	    if {[llength $bits] == 2} {
		incr exponent [expr {-[string length [lindex $bits 1]]}]
		set mantissa [join $bits ""]
	    }
	    # Trim useless leading zeroes
	    return [list [regsub {^([-+]?)0*([0-9])} $mantissa {\1\2}] $exponent]
	}

	proc Normalize {n} {
	    lassign $n mantissa exponent
	    # Trim useless trailing zeroes
	    while {[regexp {^([-+]?.+?)(0+)$} $mantissa -> head tail]} {
		set mantissa $head
		incr exponent [string length $tail]
	    }
	    # Human-readable form, please
	    return ${mantissa}e${exponent}
	}

	# Addition and multiplication on pairs of arbitrary-precision floats,
	# in decomposed form
	proc Add {a b} {
	    lassign $a am ae
	    lassign $b bm be
	    set de [expr {$ae - $be}]
	    if {$de < 0} {
		append bm [string repeat 0 [expr {-$de}]]
	    } elseif {$de > 0} {
		incr ae [expr {-$de}]
		append am [string repeat 0 $de]
	    }
	    list [expr {$am+$bm}] $ae
	}
	proc Mul {a b} {
	    lassign $a am ae
	    lassign $b bm be
	    list [expr {$am * $bm}] [expr {$ae + $be}]
	}
    }
}

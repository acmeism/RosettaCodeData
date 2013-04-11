oo::class create NG2 {
    variable a b a1 b1 a2 b2 a12 b12 cf1 cf2
    superclass Generator
    constructor {args} {
	lassign $args a12 a1 a2 a b12 b1 b2 b
	next
    }
    method operands {N1 N2} {
	set cf1 $N1
	set cf2 $N2
	return [self]
    }

    method Ingress1 t {
	lassign [list [expr {$a2+$a12*$t}] [expr {$a+$a1*$t}] $a12 $a1 \
		      [expr {$b2+$b12*$t}] [expr {$b+$b1*$t}] $b12 $b1] \
	    a12 a1 a2 a b12 b1 b2 b
    }
    method Exhaust1 {} {
	lassign [list $a12 $a1 $a12 $a1 $b12 $b1 $b12 $b1] \
	    a12 a1 a2 a b12 b1 b2 b
    }
    method Ingress2 t {
	lassign [list [expr {$a1+$a12*$t}] $a12 [expr {$a+$a2*$t}] $a2 \
		      [expr {$b1+$b12*$t}] $b12 [expr {$b+$b2*$t}] $b2] \
	    a12 a1 a2 a b12 b1 b2 b
    }
    method Exhaust2 {} {
	lassign [list $a12 $a12 $a2 $a2 $b12 $b12 $b2 $b2] \
	    a12 a1 a2 a b12 b1 b2 b
    }
    method Egress {} {
	set t [expr {$a/$b}]
	lassign [list $b12 $b1 $b2 $b \
		    [expr {$a12 - $b12*$t}] [expr {$a1 - $b1*$t}] \
		    [expr {$a2 - $b2*$t}] [expr {$a - $b*$t}]] \
	    a12 a1 a2 a b12 b1 b2 b
	return $t
    }

    method DoIngress1 {} {
	try {tailcall my Ingress1 [$cf1]} on break {} {}
	oo::objdefine [self] forward DoIngress1 my Exhaust1
	set cf1 ""
	tailcall my Exhaust1
    }
    method DoIngress2 {} {
	try {tailcall my Ingress2 [$cf2]} on break {} {}
	oo::objdefine [self] forward DoIngress2 my Exhaust2
	set cf2 ""
	tailcall my Exhaust2
    }
    method Ingress {} {
	if {$b==0} {
	    if {$b2 == 0} {
		tailcall my DoIngress1
	    } else {
		tailcall my DoIngress2
	    }
	}
	if {!$b2} {
	    tailcall my DoIngress2
	}
	if {!$b1} {
	    tailcall my DoIngress1
	}
	if {[my FirstSource?]} {
	    tailcall my DoIngress1
	} else {
	    tailcall my DoIngress2
	}
    }

    method FirstSource? {} {
	expr {abs($a1*$b*$b2 - $a*$b1*$b2) > abs($a2*$b*$b1 - $a*$b1*$b2)}
    }
    method NeedTerm? {} {
	expr {
	    ($b*$b1*$b2*$b12==0) ||
	    !($a/$b == $a1/$b1 && $a/$b == $a2/$b2 && $a/$b == $a12/$b12)
	}
    }
    method Done? {} {
	expr {$b==0 && $b1==0 && $b2==0 && $b12==0}
    }

    method Produce {} {
	# Until we've drained both continued fractions...
	while {$cf1 ne "" || $cf2 ne ""} {
	    if {[my NeedTerm?]} {
		my Ingress
	    } else {
		yield [my Egress]
	    }
	}
	# Drain our internal state
	while {![my Done?]} {
	    yield [my Egress]
	}
    }
}

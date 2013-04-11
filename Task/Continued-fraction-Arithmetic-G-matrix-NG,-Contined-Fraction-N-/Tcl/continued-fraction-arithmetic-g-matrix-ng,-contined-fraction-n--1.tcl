# The single-operand version of the NG operator, using our little generator framework
oo::class create NG1 {
    superclass Generator

    variable a1 a b1 b cf
    constructor args {
	next
	lassign $args a1 a b1 b
    }
    method Ingress n {
	lassign [list [expr {$a + $a1*$n}] $a1 [expr {$b + $b1*$n}] $b1] \
	    a1 a b1 b
    }
    method NeedTerm? {} {
	expr {$b1 == 0 || $b == 0 || $a/$b != $a1/$b1}
    }
    method Egress {} {
	set n [expr {$a/$b}]
	lassign [list $b1 $b [expr {$a1 - $b1*$n}] [expr {$a - $b*$n}]] \
	    a1 a b1 b
	return $n
    }
    method EgressDone {} {
	if {[my NeedTerm?]} {
	    set a $a1
	    set b $b1
	}
	tailcall my Egress
    }
    method Done? {} {
	expr {$b1 == 0 && $b == 0}
    }

    method operand {N} {
	set cf $N
	return [self]
    }
    method Produce {} {
	while 1 {
	    set n [$cf]
	    if {![my NeedTerm?]} {
		yield [my Egress]
	    }
	    my Ingress $n
	}
	while {![my Done?]} {
	    yield [my EgressDone]
	}
    }
}

package require Tcl 8.6

oo::class create Fractran {
    variable fracs nco
    constructor {fractions} {
	set fracs {}
	foreach frac $fractions {
	    if {[regexp {^(\d+)/(\d+),?$} $frac -> num denom]} {
		lappend fracs $num $denom
	    } else {
		return -code error "$frac is not a supported fraction"
	    }
	}
	if {![llength $fracs]} {
	    return -code error "need at least one fraction"
	}
    }

    method execute {n {steps 15}} {
	set co [coroutine [incr nco] my Generate $n]
	for {set i 0} {$i < $steps} {incr i} {
	    lappend result [$co]
	}
	catch {rename $co ""}
	return $result
    }

    method Step {n} {
	foreach {num den} $fracs {
	    if {$n % $den} continue
	    return [expr {$n * $num / $den}]
	}
	return -code break
    }
    method Generate {n} {
	yield [info coroutine]
	while 1 {
	    yield $n
	    set n [my Step $n]
	}
	return -code break
    }
}

set ft [Fractran new {
    17/91 78/85 19/51 23/38 29/33 77/29 95/23
    77/19 1/17 11/13 13/11 15/14 15/2 55/1
}]
puts [$ft execute 2]

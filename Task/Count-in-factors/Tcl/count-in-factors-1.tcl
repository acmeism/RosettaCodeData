package require Tcl 8.5

namespace eval prime {
    variable primes [list 2 3 5 7 11]
    proc restart {} {
	variable index -1
	variable primes
	variable current [lindex $primes end]
    }

    proc get_next_prime {} {
	variable primes
	variable index
	if {$index < [llength $primes]-1} {
	    return [lindex $primes [incr index]]
	}
	variable current
	while 1 {
	    incr current 2
	    set p 1
	    foreach prime $primes {
		if {$current % $prime} {} else {
		    set p 0
		    break
		}
	    }
	    if {$p} {
		return [lindex [lappend primes $current] [incr index]]
	    }
	}
    }

    proc factors {num} {
	restart
	set factors [dict create]
	for {set i [get_next_prime]} {$i <= $num} {} {
	    if {$num % $i == 0} {
		dict incr factors $i
		set num [expr {$num / $i}]
		continue
	    } elseif {$i*$i > $num} {
		dict incr factors $num
		break
	    } else {
		set i [get_next_prime]
	    }
	}
	return $factors
    }

    # Produce the factors in rendered form
    proc factors.rendered {num} {
	set factorDict [factors $num]
	if {[dict size $factorDict] == 0} {
	    return 1
	}
	dict for {factor times} $factorDict {
	    lappend v {*}[lrepeat $times $factor]
	}
	return [join $v "*"]
    }
}

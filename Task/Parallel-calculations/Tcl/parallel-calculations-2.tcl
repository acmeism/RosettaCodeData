# Code for computing the prime factors of a number
set computationCode {
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
    }
}

# The values to be factored
set values {
    188573867500151328137405845301
    3326500147448018653351160281
    979950537738920439376739947
    2297143294659738998811251
    136725986940237175592672413
    3922278474227311428906119
    839038954347805828784081
    42834604813424961061749793
    2651919914968647665159621
    967022047408233232418982157
    2532817738450130259664889
    122811709478644363796375689
}

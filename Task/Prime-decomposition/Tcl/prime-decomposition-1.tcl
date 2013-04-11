namespace eval primes {}

proc primes::reset {} {
    variable list [list]
    variable current_index end
}

namespace eval primes {reset}

proc primes::restart {} {
    variable list
    variable current_index
    if {[llength $list] > 0} {
        set current_index 0
    }
}

proc primes::is_prime {candidate} {
    variable list

    if {$candidate in $list} {return true}
    foreach prime $list {
        if {$candidate % $prime == 0} {
            return false
        }
        if {$prime * $prime > $candidate} {
            return true
        }
    }
    while true {
        set largest [get_next_prime]
        if {$largest * $largest >= $candidate} {
            return [is_prime $candidate]
        }
    }
}

proc primes::get_next_prime {} {
    variable list
    variable current_index

    if {$current_index ne "end"} {
        set p [lindex $list $current_index]
        if {[incr current_index] == [llength $list]} {
            set current_index end
        }
        return $p
    }

    switch -exact -- [llength $list] {
        0 {set candidate 2}
        1 {set candidate 3}
        default {
            set candidate [lindex $list end]
            while true {
                incr candidate 2
                if {[is_prime $candidate]} break
            }
        }
    }
    lappend list $candidate
    return $candidate
}

# return the prime factors of a number in a dictionary.
# The keys will be the factors, the value will be the number
# of times the factor divides the given number
#
# example: 120 = 2**3 * 3 * 5, so
# [primes::factors 120] returns 2 3 3 1 5 1
# so:  set prod 1
#      dict for {p e} [primes::factors 120] {
#          set prod [expr {$prod * $p**$e}]
#      }
#      expr {$prod  == 120} ;# ==> true
#
proc primes::factors {num} {
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

#!/usr/bin/env  tclsh

package require generator

generator define idx_range {n m} {
    for {set i $n} {$i < [expr $m -1]} {incr i} { generator yield $i }
}

generator define mth_power {m} {
    set n 0
    while {1} {
	    generator yield  [expr $n ** $m]
	    incr n
    }
}

generator define squares {} {

    generator for x [mth_power 2] {
	    generator yield $x
    }
}

generator define cubes {} {

    generator for x [mth_power 3] {
	    generator yield $x
    }
}

set acc {} ; # accumulator

set comm {} ; # common result

set limit 50

# run both generators concurrently

generator foreach x [squares] y [cubes] {

    lappend acc $y

    if { ! [expre {$x in $acc}] } { lappend comm $x }

    if { [llength $comm] > $limit } {break}
}

# elements 20.. 30
set results  [lrange $comm 19 29] ; # list range

generator foreach idx [idx_range 20 30] {
    set x [lindex $comm $idx]
    puts "$x"
}

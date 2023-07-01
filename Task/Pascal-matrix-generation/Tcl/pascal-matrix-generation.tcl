package require math

namespace eval pascal {
    proc upper {n} {
        for {set i 0} {$i < $n} {incr i} {
            for {set j 0} {$j < $n} {incr j} {
                puts -nonewline \t[::math::choose $j $i]
            }
            puts ""
        }
    }
    proc lower {n} {
        for {set i 0} {$i < $n} {incr i} {
            for {set j 0} {$j < $n} {incr j} {
                puts -nonewline \t[::math::choose $i $j]
            }
            puts ""
        }
    }
    proc symmetric {n} {
        for {set i 0} {$i < $n} {incr i} {
            for {set j 0} {$j < $n} {incr j} {
                puts -nonewline \t[::math::choose [expr {$i+$j}] $i]
            }
            puts ""
        }
    }
}

foreach type {upper lower symmetric} {
    puts "\n* $type"
    pascal::$type 5
}

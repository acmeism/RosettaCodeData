catch {namespace delete test_convex_hull} ;# Start with a clean namespace

namespace eval test_convex_hull {
    package require Tcl 8.5 ;# maybe earlier?
    interp alias {} @ {} lindex;# An essential readability helper for list indexing

    proc cross {o a b} {
        ### 2D cross product of OA and OB vectors ###
        return [expr {([@ $a 0] - [@ $o 0]) * ([@ $b 1] - [@ $o 1]) - ([@ $a 1] - [@ $o 1]) * ([@ $b 0] - [@ $o 0]) }]
    }

    proc calc_hull_edge {points} {
        ### Build up hull edge ###
        set edge [list]
        foreach p $points {
            while {[llength $edge ] >= 2 && [cross [@ $edge end-1] [@ $edge end] $p] <= 0} {
                set edge [lreplace $edge end end] ;# pop
            }
            lappend edge $p
        }
        return $edge
    }

    proc convex_hull {points} {
        ### Convex hull of a set of 2D points ###

        # Unique points
        set points [lsort -unique $points]

        # Sorted points
        set points [lsort -real -index 0 [lsort -real -index 1 $points]]

        # No calculation necessary
        if {[llength $points] <= 1} {
            return $points
        }

        set lower [calc_hull_edge $points]
        set upper [calc_hull_edge [lreverse $points]]

        return [concat [lrange $lower 0 end-1] [lrange $upper 0 end-1]]
    }

    # Testing
    set tpoints {{16 3} {12 17} {0 6} {-4 -6} {16 6}  {16 -7} {16 -3} {17 -4} {5 19}  {19 -8}
                 {3 16} {12 13} {3 -4} {17 5} {-3 15} {-3 -9} {0 11}  {-9 -3} {-4 -2} {12 10}}

    puts "Test points:"
    puts [lrange $tpoints 0 end] ;# prettier
    puts "Convex Hull:"
    puts [convex_hull $tpoints]
}

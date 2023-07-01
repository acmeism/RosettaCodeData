# Loop over adjacent pairs in a list.
# Example:
#  % eachpair {a b} {1 2 3} {puts $a $b}
#  1 2
#  2 3
proc eachpair {varNames ls script} {
    if {[lassign $varNames _i _j] ne ""} {
        return -code error "Must supply exactly two arguments"
    }
    tailcall foreach $_i [lrange $ls 0 end-1] $_j [lrange $ls 1 end] $script
}

namespace eval numbrix {

    namespace path {::tcl::mathop ::tcl::mathfunc}

    proc parse {txt} {
        set map [split [string trim $txt] \n]
    }

    proc print {map} {
        join [lmap row $map {
            join [lmap val $row {
                format %2d $val
            }] " "
        }] \n
    }

    proc mark {map x y i} {
        lset map $x $y $i
    }

    proc moves {x y} {
        foreach {dx dy} {
                0  1
            -1 0      1 0
                0 -1
        } {
            lappend r [+ $dx $x] [+ $dy $y]
        }
        return $r
    }

    proc rmap {map} {   ;# generate a reverse map in a dict {val {x y} ..}
        set rmap {}
        set h [llength $map]
        set w [llength [lindex $map 0]]
        set x $w
        while {[incr x -1]>=0} {
            set y $h
            while {[incr y -1]>=0} {
                set i [lindex $map $x $y]
                if {$i} {
                    dict set rmap [lindex $map $x $y] [list $x $y]
                }
            }
        }
        return $rmap
    }

    proc gaps {rmap} {  ;# list all the gaps to be filled
        set known [lsort -integer [dict keys $rmap]]
        set gaps {}
        eachpair {i j} $known {
            if {$j > $i+1} {
                lappend gaps $i $j
            }
        }
        return $gaps
    }

    proc fixgaps {map rmap gaps} {  ;# add a "tail" gap if needed
        set w [llength $map]
        set h [llength [lindex $map 0]]
        set size [* $h $w]
        set max [max {*}[dict keys $rmap]]
        if {$max ne $size} {
            lappend gaps $max Inf
        }
        return $gaps
    }


    proc paths {map x0 y0 n} {  ;# generate all the maps with a single path filled legally
        if {$n == 0} {return [list $map]}
        set i [lindex $map $x0 $y0]
        set paths {}
        foreach {x y} [moves $x0 $y0] {
            set j [lindex $map $x $y]
            if {$j eq ""} {
                continue
            } elseif {$j == 0 && $n == $n+1} {
                return [list [mark $map $x $y [+ $i 1]]]
            } elseif {$j == $i+1} {
                lappend paths $map
                continue
            } elseif {$j || ($n == 1)} {
                continue
            } else {
                lappend paths {*}[
                    paths [
                        mark $map $x $y [+ $i 1]
                    ] $x $y [- $n 1]
                ]
            }
        }
        return $paths
    }

    proc solve {map} {
        # fixpoint map
        while 1 {   ;# first we iteratively fill in paths with distinct solutions
            set rmap [rmap $map]
            set gaps [gaps $rmap]
            set gaps [fixgaps $map $rmap $gaps]
            if {$gaps eq ""} {
                return $map
            }
            set oldmap $map
            foreach {i j} $gaps {
                lassign [dict get $rmap $i] x0 y0
                set n [- $j $i]
                set paths [paths $map $x0 $y0 $n]
                if {$paths eq ""} {
                    return ""
                } elseif {[llength $paths] == 1} {
                    #puts "solved $i..$j"
                    #puts [print $map]
                    set map [lindex $paths 0]
                }
                ;# we could intersect the paths to maybe get some tiles
            }
            if {$map eq $oldmap} {
                break
            }
        }
        #puts "unique paths exhausted - going DFS"
        try {   ;# for any left over paths, go DFS
            ;# we might want to sort the gaps first
            foreach {i j} $gaps {
                lassign [dict get $rmap $i] x0 y0
                set n [- $j $i]
                set paths [paths $map $x0 $y0 $n]
                foreach path $paths {
                    #puts "recursing on $i..$j"
                    set sol [solve $path]
                    if {$sol ne ""} {
                        return $sol
                    }
                }
            }
        }
    }

    namespace export {[a-z]*}
    namespace ensemble create
}

set puzzles {
    {
        0  0  0  0  0  0  0  0  0
        0  0 46 45  0 55 74  0  0
        0 38  0  0 43  0  0 78  0
        0 35  0  0  0  0  0 71  0
        0  0 33  0  0  0 59  0  0
        0 17  0  0  0  0  0 67  0
        0 18  0  0 11  0  0 64  0
        0  0 24 21  0  1  2  0  0
        0  0  0  0  0  0  0  0  0
    }

    {
        0  0  0  0  0  0  0  0  0
        0 11 12 15 18 21 62 61  0
        0  6  0  0  0  0  0 60  0
        0 33  0  0  0  0  0 57  0
        0 32  0  0  0  0  0 56  0
        0 37  0  1  0  0  0 73  0
        0 38  0  0  0  0  0 72  0
        0 43 44 47 48 51 76 77  0
        0  0  0  0  0  0  0  0  0
    }
}


foreach puzzle $puzzles {
    set map [numbrix parse $puzzle]
    puts "\n== Puzzle [incr i] =="
    puts [numbrix print $map]
    set sol [numbrix solve $map]
    if {$sol ne ""} {
        puts "\n== Solution $i =="
        puts [numbrix print $sol]
    } else {
        puts "\n== No Solution for Puzzle $i =="
    }
}

package require TclOO

oo::class create Playfair {
    variable grid lookup excluder
    constructor {{keyword "PLAYFAIR EXAMPLE"} {exclude "J"}} {
        # Tweaking according to exact operation mode
        if {$exclude eq "J"} {
            set excluder "J I"
        } else {
            set excluder [list $exclude ""]
        }

        # Clean up the keyword source
        set keys [my Clean [append keyword "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]]

        # Generate the encoding grid
        set grid [lrepeat 5 [lrepeat 5 ""]]
        set idx -1
        for {set i 0} {$i < 5} {incr i} {for {set j 0} {$j < 5} {} {
            if {![info exist lookup([set c [lindex $keys [incr idx]]])]} {
                lset grid $i $j $c
                set lookup($c) [list $i $j]
                incr j
            }
        }}

        # Sanity check
        if {[array size lookup] != 25} {
            error "failed to build encoding table correctly"
        }
    }

    # Worker to apply a consistent cleanup/split rule
    method Clean {str} {
        set str [string map $excluder [string toupper $str]]
        split [regsub -all {[^A-Z]} $str ""] ""
    }

    # These public methods are implemented by a single non-public method
    forward encode my Transform 1
    forward decode my Transform -1

    # The application of the Playfair cypher transform
    method Transform {direction message} {
        # Split message into true digraphs
        foreach c [my Clean $message] {
            if {![info exists lookup($c)]} continue
            if {![info exists c0]} {
                set c0 $c
            } else {
                if {$c0 ne $c} {
                    lappend digraphs $c0 $c
                    unset c0
                } else {
                    lappend digraphs $c0 "X"
                    set c0 $c
                }
            }
        }
        if {[info exists c0]} {
            lappend digraphs $c0 "Z"
        }

        # Encode the digraphs
        set result ""
        foreach {a b} $digraphs {
            lassign $lookup($a) ai aj
            lassign $lookup($b) bi bj
            if {$ai == $bi} {
                set aj [expr {($aj + $direction) % 5}]
                set bj [expr {($bj + $direction) % 5}]
            } elseif {$aj == $bj} {
                set ai [expr {($ai + $direction) % 5}]
                set bi [expr {($bi + $direction) % 5}]
            } else {
                set tmp $aj
                set aj $bj
                set bj $tmp
            }
            lappend result [lindex $grid $ai $aj][lindex $grid $bi $bj]
        }

        # Real use would be: return [join $result ""]
        return $result
    }
}

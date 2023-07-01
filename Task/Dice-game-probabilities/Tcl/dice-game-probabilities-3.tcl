package require Tcl 8.6    ;# for [tailcall] - otherwise use [uplevel 1 $script]
# This proc builds up a nested foreach call, then evaluates it.
#
# this:
#   foreach* a {1 2 3} b {4 5 6} {
#     puts "$a + $b"
#   }
#
# becomes:
#   foreach a {1 2 3} {
#     foreach b {4 5 6} {
#       puts "$a + $b"
#     }
#   }
proc foreach* {args} {
    set script [lindex $args end]
    set args [lrange $args 0 end-1]
    foreach {b a} [lreverse $args] {
        set script [list foreach $a $b $script]
    }
    tailcall {*}$script
}

proc NdK {n {k 6}} {    ;# calculate a score histogram for $n dice of $k faces

    set args {}     ;# arguments to [foreach*]
    set vars {}     ;# variables used in [foreach*] arguments that need to be added to sum
    set sum {}      ;# this will be the result dictionary

    for {set i 0} {$i < $n} {incr i} {
        lappend args d$i [range $k]
        lappend vars "\$d$i"
    }

    set vars [join $vars +]

    # [string map] to avoid "Quoting Hell"
    set script [string map [list %% $vars] {
        dict incr sum [expr {$n + %%}]  ;# $n because [range] is 0-based
    }]

    foreach* {*}$args $script
    return $sum
}

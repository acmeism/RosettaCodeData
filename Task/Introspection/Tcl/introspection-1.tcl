package require Tcl 8.4 ; # throws an error if older
if {[info exists bloop] && [llength [info functions abs]]} {
    puts [expr abs($bloop)]
}

#! /usr/bin/env tclsh

package require Tcl 8.6

# By aspect (https://wiki.tcl-lang.org/page/aspect).  Modified slightly.
# 1. Schedule N delayed calls to our own coroutine.
# 2. Yield N times to grab the scheduled values.  Print each.
# 3. Store the sorted list in $varName.
proc sleep-sort {ls varName} {
    foreach x $ls {
        after $x [info coroutine] $x
    }

    set $varName [lmap x $ls {
        set newX [yield]
        puts $newX
        lindex $newX
    }]
}

# Ensure the list is suitable for use with [sleep-sort].
proc validate ls {
    if {[llength $ls] == 0} {
        error {list is empty}
    }

    foreach x $ls {
        if {![string is integer -strict $x] || $x < 0} {
            error [list invalid value: $x]
        }
    }

    return $ls
}

coroutine c sleep-sort [validate $argv] ::sorted
vwait sorted

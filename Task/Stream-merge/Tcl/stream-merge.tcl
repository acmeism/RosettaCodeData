#!/usr/bin/env tclsh
proc merge {args} {
    set peeks {}
    foreach chan $args {
        if {[gets $chan peek] > 0} {
            dict set peeks $chan $peek
        }
    }
    set peeks [lsort -stride 2 -index 1 $peeks]
    while {[dict size $peeks]} {
        set peeks [lassign $peeks chan peek]
        puts $peek
        if {[gets $chan peek] > 0} {
            dict set peeks $chan $peek
            set peeks [lsort -stride 2 -index 1 $peeks]
        }
    }
}

merge {*}[lmap f $::argv {open $f r}]

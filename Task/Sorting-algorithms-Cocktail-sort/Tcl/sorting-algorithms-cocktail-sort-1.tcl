package require Tcl 8.5
package require struct::list

proc cocktailsort {A} {
    set len [llength $A]
    set swapped true
    while {$swapped} {
        set swapped false
        for {set i 0} {$i < $len - 1} {incr i} {
            set j [expr {$i + 1}]
            if {[lindex $A $i] > [lindex $A $j]} {
                struct::list swap A $i $j
                set swapped true
            }
        }
        if { ! $swapped} {
            break
        }
        set swapped false
        for {set i [expr {$len - 2}]} {$i >= 0} {incr i -1} {
            set j [expr {$i + 1}]
            if {[lindex $A $i] > [lindex $A $j]} {
                struct::list swap A $i $j
                set swapped true
            }
        }
    }
    return $A
}

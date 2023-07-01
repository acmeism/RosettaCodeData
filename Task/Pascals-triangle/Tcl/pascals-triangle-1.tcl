proc pascal_iterative n {
    if {$n < 1} {error "undefined behaviour for n < 1"}
    set row [list 1]
    lappend rows $row
    set i 1
    while {[incr i] <= $n} {
        set prev $row
        set row [list 1]
        for {set j 1} {$j < [llength $prev]} {incr j} {
            lappend row [expr {[lindex $prev [expr {$j - 1}]] + [lindex $prev $j]}]
        }
        lappend row 1
        lappend rows $row
    }
    return $rows
}

puts [join [pascal_iterative 6] \n]

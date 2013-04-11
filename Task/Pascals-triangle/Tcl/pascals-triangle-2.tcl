proc pascal_coefficients n {
    if {$n < 1} {error "undefined behaviour for n < 1"}
    for {set i 0} {$i < $n} {incr i} {
        set c 1
        set row [list $c]
        for {set j 0} {$j < $i} {incr j} {
            set c [expr {$c * ($i - $j) / ($j + 1)}]
            lappend row $c
        }
        lappend rows $row
    }
    return $rows
}

puts [join [pascal_coefficients 6] \n]

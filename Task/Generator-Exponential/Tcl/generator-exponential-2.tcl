package require Tcl 8.6
package require generator

generator define range {n m} {
    for {set i $n} {$i <= $m} {incr i} {
        generator yield $i
    }
}

generator foreach x [range 22 35] {
    puts -nonewline  stdout "${x}  "
}
puts stdout ""

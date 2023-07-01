proc spi2 {from to} {
    for {set i $from} {$i<=$to} {incr i} {
	lappend result [list [expr {$i+1./6}] 0 [expr {$i+5./6}] 0]
    }
    return [intersection [list [list $from 0 $to 0]] $result]
}
proc applyfunc {var func} {
    upvar 1 $var A
    for {set i 0} {$i < [llength $A]} {incr i} {
	lassign [lindex $A $i] a - b -
	lset A $i 0 [$func $a]
	lset A $i 2 [$func $b]
    }
}
set A [spi2 0 100]
applyfunc A ::tcl::mathfunc::sqrt
set B [spi2 0 10]
set AB [difference $A $B]
puts "[llength $AB] contiguous subsets, total length [length $AB]"

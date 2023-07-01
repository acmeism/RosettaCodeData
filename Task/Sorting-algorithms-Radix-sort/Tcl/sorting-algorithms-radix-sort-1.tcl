package require Tcl 8.5
proc splitByRadix {lst base power} {
    # create a list of empty lists to hold the split by digit
    set out [lrepeat [expr {$base*2}] {}]
    foreach item $lst {
	# pulls the selected digit
	set digit [expr {($item / $base ** $power) % $base + $base * ($item >= 0)}]
	# append the number to the list selected by the digit
	lset out $digit [list {*}[lindex $out $digit] $item]
    }
    return $out
}

# largest abs value element of a list
proc tcl::mathfunc::maxabs {lst} {
    set max [abs [lindex $lst 0]]
    for {set i 1} {$i < [llength $lst]} {incr i} {
	set v [abs [lindex $lst $i]]
	if {$max < $v} {set max $v}
    }
    return $max
}

proc radixSort {lst {base 10}} {
    # there are as many passes as there are digits in the longest number
    set passes [expr {int(log(maxabs($lst))/log($base) + 1)}]
    # For each pass...
    for {set pass 0} {$pass < $passes} {incr pass} {
	# Split by radix, then merge back into the list
	set lst [concat {*}[splitByRadix $lst $base $pass]]
    }
    return $lst
}

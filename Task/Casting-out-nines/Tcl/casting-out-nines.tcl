proc co9 {x} {
    while {[string length $x] > 1} {
	set x [tcl::mathop::+ {*}[split $x ""]]
    }
    return $x
}
# Extended to the general case
proc coBase {x {base 10}} {
    while {$x >= $base} {
	for {set digits {}} {$x} {set x [expr {$x / $base}]} {
	    lappend digits [expr {$x % $base}]
	}
	set x [tcl::mathop::+ {*}$digits]
    }
    return $x
}

# Simple helper
proc percent {part whole} {format "%.2f%%" [expr {($whole - $part) * 100.0 / $whole}]}

puts "In base 10..."
set satisfying {}
for {set i 1} {$i < 100} {incr i} {
    if {[co9 $i] == [co9 [expr {$i*$i}]]} {
	lappend satisfying $i
    }
}
puts $satisfying
puts "Trying [llength $satisfying] numbers instead of 99 numbers saves [percent [llength $satisfying] 99]"

puts "In base 16..."
set satisfying {}
for {set i 1} {$i < 256} {incr i} {
    if {[coBase $i 16] == [coBase [expr {$i*$i}] 16]} {
	lappend satisfying $i
    }
}
puts $satisfying
puts "Trying [llength $satisfying] numbers instead of 255 numbers saves [percent [llength $satisfying] 255]"

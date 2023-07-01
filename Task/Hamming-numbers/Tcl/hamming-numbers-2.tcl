variable hamming 1 hi2 0 hi3 0 hi5 0
proc hamming {n} {
    global hamming hi2 hi3 hi5
    set h2 [expr {[lindex $hamming $hi2]*2}]
    set h3 [expr {[lindex $hamming $hi3]*3}]
    set h5 [expr {[lindex $hamming $hi5]*5}]
    while {[llength $hamming] < $n} {
	lappend hamming [set h [expr {
	    $h2<$h3
	        ? $h2<$h5 ? $h2 : $h5
	        : $h3<$h5 ? $h3 : $h5
	}]]
	if {$h==$h2} {
	    set h2 [expr {[lindex $hamming [incr hi2]]*2}]
	}
	if {$h==$h3} {
	    set h3 [expr {[lindex $hamming [incr hi3]]*3}]
	}
	if {$h==$h5} {
	    set h5 [expr {[lindex $hamming [incr hi5]]*5}]
	}
    }
    return [lindex $hamming [expr {$n - 1}]]
}

# Print the first 20 values of the sequence
for {set i 1} {$i <= 20} {incr i} {
    puts [format "hamming\[%d\] = %d" $i [hamming $i]]
}
puts "hamming{1690} = [hamming 1690]"
puts "hamming{1691} = [hamming 1691]"
puts "hamming{1692} = [hamming 1692]"
puts "hamming{1693} = [hamming 1693]"
puts "hamming{1000000} = [hamming 1000000]"

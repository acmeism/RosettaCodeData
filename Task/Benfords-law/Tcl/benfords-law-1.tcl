proc benfordTest {numbers} {
    # Count the leading digits (RE matches first digit in each number,
    # even if negative)
    set accum {1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0}
    foreach n $numbers {
	if {[regexp {[1-9]} $n digit]} {
	    dict incr accum $digit
	}
    }

    # Print the report
    puts " digit | measured | theory"
    puts "-------+----------+--------"
    dict for {digit count} $accum {
	puts [format "%6d | %7.2f%% | %5.2f%%" $digit \
		  [expr {$count * 100.0 / [llength $numbers]}] \
		  [expr {log(1+1./$digit)/log(10)*100.0}]]
    }
}

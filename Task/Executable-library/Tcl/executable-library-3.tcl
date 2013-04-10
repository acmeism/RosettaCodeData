#!/usr/bin/tclsh8.6
package require Tcl 8.6	;# For [lsort -stride] option
lappend auto_path .		;# Or wherever it is located
package require hailstone 1.0

# Construct a histogram of length frequencies
set histogram {}
for {set n 1} {$n < 100000} {incr n} {
    dict incr histogram [llength [hailstone $n]]
}

# Identify the most common length by sorting...
set sortedHist [lsort -decreasing -stride 2 -index 1 $histogram]
lassign $sortedHist mostCommonLength freq

puts "most common length is $mostCommonLength, with frequency $freq"

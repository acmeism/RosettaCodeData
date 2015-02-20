package require Tcl 8.5
proc stats {size} {
    set sum 0.0
    set sum2 0.0
    for {set i 0} {$i < $size} {incr i} {
	set r [expr {rand()}]

	incr histo([expr {int(floor($r*10))}])
	set sum [expr {$sum + $r}]
	set sum2 [expr {$sum2 + $r**2}]
    }
    set mean [expr {$sum / $size}]
    set stddev [expr {sqrt($sum2/$size - $mean**2)}]
    puts "$size numbers"
    puts "Mean:   $mean"
    puts "StdDev: $stddev"
    foreach i {0 1 2 3 4 5 6 7 8 9} {
	# The 205 is a magic factor stolen from the Go solution
	puts [string repeat "*" [expr {$histo($i)*205/int($size)}]]
    }
}

stats 100
puts ""
stats 1000
puts ""
stats 10000

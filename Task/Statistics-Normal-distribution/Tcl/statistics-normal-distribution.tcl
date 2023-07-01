package require Tcl 8.5
# Uses the Box-Muller transform to compute a pair of normal random numbers
proc tcl::mathfunc::nrand {mean stddev} {
    variable savednormalrandom
    if {[info exists savednormalrandom]} {
	return [expr {$savednormalrandom*$stddev + $mean}][unset savednormalrandom]
    }
    set r [expr {sqrt(-2*log(rand()))}]
    set theta [expr {2*3.1415927*rand()}]
    set savednormalrandom [expr {$r*sin($theta)}]
    expr {$r*cos($theta)*$stddev + $mean}
}
proc stats {size {slotfactor 10}} {
    set sum 0.0
    set sum2 0.0
    for {set i 0} {$i < $size} {incr i} {
	set r [expr { nrand(0.5, 0.2) }]

	incr histo([expr {int(floor($r*$slotfactor))}])
	set sum [expr {$sum + $r}]
	set sum2 [expr {$sum2 + $r**2}]
    }
    set mean [expr {$sum / $size}]
    set stddev [expr {sqrt($sum2/$size - $mean**2)}]
    puts "$size numbers"
    puts "Mean:   $mean"
    puts "StdDev: $stddev"
    foreach i [lsort -integer [array names histo]] {
	puts [string repeat "*" [expr {$histo($i)*350/int($size)}]]
    }
}

stats 100
puts ""
stats 1000
puts ""
stats 10000
puts ""
stats 100000 20

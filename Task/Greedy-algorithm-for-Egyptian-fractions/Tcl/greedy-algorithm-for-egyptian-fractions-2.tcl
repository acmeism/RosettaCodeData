package require Tcl 8.6

proc efrac {fraction} {
    scan $fraction "%d/%d" x y
    set prefix ""
    if {$x > $y} {
	set whole [expr {$x / $y}]
	set x [expr {$x - $whole*$y}]
	set prefix "\[$whole\] + "
    }
    return $prefix[join [lmap y [egyptian $x $y] {format "1/%lld" $y}] " + "]
}

foreach f {43/48  5/121  2014/59} {
    puts "$f = [efrac $f]"
}
set maxt 0
set maxtf {}
set maxd 0
set maxdf {}
for {set d 1} {$d < 100} {incr d} {
    for {set n 1} {$n < $d} {incr n} {
	set e [egyptian $n $d]
	if {[llength $e] >= $maxt} {
	    set maxt [llength $e]
	    set maxtf $n/$d
	}
	if {[lindex $e end] > $maxd} {
	    set maxd [lindex $e end]
	    set maxdf $n/$d
	}
    }
}
puts "$maxtf has maximum number of terms = [efrac $maxtf]"
puts "$maxdf has maximum denominator = [efrac $maxdf]"

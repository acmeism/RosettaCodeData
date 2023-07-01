package require Tcl 8.6

# http://www.cut-the-knot.org/Curriculum/Algorithms/SpigotForPi.shtml
# http://www.mathpropress.com/stan/bibliography/spigot.pdf
proc piDigitsBySpigot n {
    yield [info coroutine]
    set A [lrepeat [expr {int(floor(10*$n/3.)+1)}] 2]
    set Alen [llength $A]
    set predigits {}
    while 1 {
	set carry 0
	for {set i $Alen} {[incr i -1] > 0} {} {
	    lset A $i [expr {
		[set val [expr {[lindex $A $i] * 10 + $carry}]]
		% [set modulo [expr {2*$i + 1}]]
	    }]
	    set carry [expr {$val / $modulo * $i}]
	}
	lset A 0 [expr {[set val [expr {[lindex $A 0]*10 + $carry}]] % 10}]
	set predigit [expr {$val / 10}]
	if {$predigit < 9} {
	    foreach p $predigits {yield $p}
	    set predigits [list $predigit]
	} elseif {$predigit == 9} {
	    lappend predigits $predigit
	} else {
	    foreach p $predigits {yield [incr p]}
	    set predigits [list 0]
	}
    }
}

proc iota {num {start 0} {step 1}} {
	set res {}
	set end [+ $start [* $step $num]]
	for {set n $start} {$n != $end} {incr n $step} {
		lappend res $n
	}
	return $res
}

puts [lsort [iota 13 1]]

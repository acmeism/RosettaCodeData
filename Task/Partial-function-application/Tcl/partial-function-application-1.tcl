package require Tcl 8.6
proc partial {f1 f2} {
    variable ctr
    coroutine __curry[incr ctr] apply {{f1 f2} {
	for {set x [info coroutine]} 1 {} {
	    set x [{*}$f1 $f2 [yield $x]]
	}
    }} $f1 $f2
}

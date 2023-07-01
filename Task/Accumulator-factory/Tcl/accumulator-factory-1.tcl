package require Tcl 8.6

# make the creation of coroutines without procedures simpler
proc coro {name arguments body args} {
    coroutine $name apply [list $arguments $body] {*}$args
}
# Wrap the feeding of values in and out of a generator
proc coloop {var body} {
    set val [info coroutine]
    upvar 1 $var v
    while 1 {
	set v [yield $val]
        if {$v eq "stop"} break
	set val [uplevel 1 $body]
    }
}

# The outer coroutine is the accumulator factory
# The inner coroutine is the particular accumulator
coro accumulator {} {
    coloop n {
	coro accumulator.[incr counter] n {
	    coloop i {
		set n [expr {$n + $i}]
	    }
	} $n
    }
}

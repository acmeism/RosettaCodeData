package require Tcl 8.6
proc cp {args} {
    coroutine cp.[incr ::cps] apply {{list args} {
	yield [info coroutine]
	foreach item $list {
	    if {[llength $args]} {
		set c [cp {*}$args]
		while 1 { yield [list $item {*}[$c]] }
	    } else { yield $item }
	}
	return -code break
    }} {*}$args
}
proc amb {name filter args} {
    coroutine $name apply {{filter args} {
	set c [cp {*}$args]
	yield [info coroutine]
	while 1 {
	    set value [$c]
	    if {[{*}$filter $value]} { yield $value }
	}
	return -code break
    }} $filter {*}$args
}

proc joins {a b} {
    expr {[string index $a end] eq [string index $b 0]}
}
proc joins* list {
    foreach a [lrange $list 0 end-1] b [lrange $list 1 end] {
	if {![joins $a $b]} {return 0}
    }
    return 1
}

amb words joins* \
    {the    that     a} \
    {frog   elephant thing} \
    {walked treaded  grows} \
    {slowly quickly}
while 1 { puts [words] }

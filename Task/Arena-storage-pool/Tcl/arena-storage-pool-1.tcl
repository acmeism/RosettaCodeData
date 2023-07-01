package require Tcl 8.6
oo::class create Pool {
    superclass oo::class
    variable capacity pool busy
    unexport create
    constructor args {
	next {*}$args
	set capacity 100
	set pool [set busy {}]
    }
    method new {args} {
	if {[llength $pool]} {
	    set pool [lassign $pool obj]
	} else {
	    if {[llength $busy] >= $capacity} {
		throw {POOL CAPACITY} "exceeded capacity: $capacity"
	    }
	    set obj [next]
	    set newobj [namespace current]::[namespace tail $obj]
	    rename $obj $newobj
	    set obj $newobj
	}
	try {
	    [info object namespace $obj]::my Init {*}$args
	} on error {msg opt} {
	    lappend pool $obj
	    return -options $opt $msg
	}
	lappend busy $obj
	return $obj
    }
    method ReturnToPool obj {
	try {
	    if {"Finalize" in [info object methods $obj -all -private]} {
		[info object namespace $obj]::my Finalize
	    }
	} on error {msg opt} {
	    after 0 [list return -options $opt $msg]
	    return false
	}
	set idx [lsearch -exact $busy $obj]
	set busy [lreplace $busy $idx $idx]
	if {[llength $pool] + [llength $busy] + 1 <= $capacity} {
	    lappend pool $obj
	    return true
	} else {
	    return false
	}
    }
    method capacity {{value {}}} {
	if {[llength [info level 0]] == 3} {
	    if {$value < $capacity} {
		while {[llength $pool] > 0 && [llength $pool] + [llength $busy] > $value} {
		    set pool [lassign $pool obj]
		    rename $obj {}
		}
	    }
	    set capacity [expr {$value >> 0}]
	} else {
	    return $capacity
	}
    }
    method clearPool {} {
	foreach obj $busy {
	    $obj destroy
	}
    }
    method destroy {} {
	my clearPool
	next
    }
    self method create {class {definition {}}} {
	set cls [next $class $definition]
	oo::define $cls method destroy {} {
	    if {![[info object namespace [self class]]::my ReturnToPool [self]]} {
		next
	    }
	}
	return $cls
    }
}

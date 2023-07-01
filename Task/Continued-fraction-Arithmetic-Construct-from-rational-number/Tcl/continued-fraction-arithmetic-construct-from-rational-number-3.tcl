package require Tcl 8.6

# General generator class based on coroutines
oo::class create Generator {
    constructor {} {
	coroutine [namespace current]::coro my Apply
    }
    destructor {
	catch {rename [namespace current]::coro {}}
    }
    method Apply {} {
	yield
        # Call the method (defined in subclasses) that actually produces values
	my Produce
	my destroy
	return -code break
    }
    forward generate coro
    method unknown args {
	if {![llength $args]} {
	    tailcall coro
	}
	next {*}$args
    }

    # Various ways to get the sequence from the generator
    method collect {} {
	set result {}
	while 1 {
	    lappend result [my generate]
	}
	return $result
    }
    method take {n {suffix ""}} {
	set result {}
	for {set i 0} {$i < $n} {incr i} {
	    lappend result [my generate]
	}
	while {$suffix ne ""} {
	    my generate
	    lappend result $suffix
	    break
	}
	return $result
    }
}

oo::class create R2CF {
    superclass Generator
    variable a b
    # The constructor converts other kinds of fraction (e.g., 1.23, 22/7) into a
    # form we can handle.
    constructor {n1 {n2 1}} {
	next;  # Delegate to superclass for coroutine management
	if {[regexp {(.*)/(.*)} $n1 -> a b]} {
	    # Nothing more to do; assume we can ignore second argument here
	} elseif {$n1 != int($n1) && [regexp {\.(\d+)} $n1 -> suffix]} {
	    set pow [string length $suffix]
	    set a [expr {int($n1 * 10**$pow)}]
	    set b [expr {$n2 * 10**$pow}]
	} else {
	    set a $n1
	    set b $n2
	}
    }
    # How to actually produce the values of the sequence
    method Produce {} {
	while {$b > 0} {
	    yield [expr {$a / $b}]
	    set b [expr {$a % [set a $b]}]
	}
    }
}

proc printcf {name cf {take ""}} {
    if {$take ne ""} {
	set terms [$cf take $take \u2026]
    } else {
	set terms [$cf collect]
    }
    puts [format "%-15s-> %s" $name [join $terms ,]]
}

foreach {n1 n2} {
    1 2
    3 1
    23 8
    13 11
    22 7
    -151 77
    14142 10000
    141421 100000
    1414214 1000000
    14142136 10000000
    31 10
    314 100
    3142 1000
    31428 10000
    314285 100000
    3142857 1000000
    31428571 10000000
    314285714 100000000
    3141592653589793 1000000000000000
} {
    printcf "\[$n1;$n2\]" [R2CF new $n1 $n2]
}
# Demonstrate parsing of input in forms other than a direct pair of decimals
printcf "1.5" [R2CF new 1.5]
printcf "23/7" [R2CF new 23/7]

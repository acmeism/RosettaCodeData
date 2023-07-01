package require Tcl 8.6

proc heappush {heapName item} {
    upvar 1 $heapName heap
    set idx [lsearch -bisect -index 0 -integer $heap [lindex $item 0]]
    set heap [linsert $heap [expr {$idx + 1}] $item]
}
coroutine cubesum apply {{} {
    yield
    set h {}
    set n 1
    while true {
	while {![llength $h] || [lindex $h 0 0] > $n**3} {
	    heappush h [list [expr {$n**3 + 1}] $n 1]
	    incr n
	}
	set h [lassign $h item]
	yield $item
	lassign $item s x y
	if {[incr y] < $x} {
	    heappush h [list [expr {$x**3 + $y**3}] $x $y]
	}
    }
}}
coroutine taxis apply {{} {
    yield
    set out {{0 0 0}}
    while true {
	set s [cubesum]
	if {[lindex $s 0] == [lindex $out end 0]} {
	    lappend out $s
	} else {
	    if {[llength $out] > 1} {yield $out}
	    set out [list $s]
	}
    }
}}

# Put a cache in front for convenience
variable taxis {}
proc taxi {n} {
    variable taxis
    while {$n > [llength $taxis]} {lappend taxis [taxis]}
    return [lindex $taxis [expr {$n-1}]]
}

set 3 "\u00b3"
for {set n 1} {$n <= 25} {incr n} {
    puts ${n}:[join [lmap t [taxi $n] {format " %d = %d$3 + %d$3" {*}$t}] ","]
}
for {set n 2000} {$n <= 2006} {incr n} {
    puts ${n}:[join [lmap t [taxi $n] {format " %d = %d$3 + %d$3" {*}$t}] ","]
}

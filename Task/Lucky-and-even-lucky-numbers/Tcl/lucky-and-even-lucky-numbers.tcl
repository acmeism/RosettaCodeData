#!/usr/bin/env tclsh8.6
package require Tcl 8.6

proc lgen {{even false} {nmax 200000}} {
    coroutine lgen.[incr ::lgen] apply {{start nmax} {
	set n 1
	for {set i $start} {$i <= $nmax+1} {incr i 2} {lappend lst $i}
	yield [info coroutine]
	yield [lindex $lst 0]
	while {$n < [llength $lst] && [lindex $lst $n] < [llength $lst]} {
	    yield [lindex $lst $n]
	    set lst [set i 0;lmap j $lst {
		if {[incr i] % [lindex $lst $n]} {set j} else continue
	    }]
	    incr n
	}
	foreach i [lrange $lst $n end] {
	    yield $i
	}
    }} [expr {$even ? 2 : 1}] $nmax
}

proc collectIndices {generator from to} {
    set result {}
    for {set i 0} {$i <= $to} {incr i} {
	set n [$generator]
	if {$i >= $from} {lappend result $n}
    }
    rename $generator {}
    return $result
}
proc collectValues {generator from to} {
    set result {}
    while 1 {
	set n [$generator]
	if {$n > $to} break
	if {$n >= $from} {lappend result $n}
    }
    rename $generator {}
    return $result
}

if {$argc<1||$argc>3} {
    puts stderr "wrong # args: should be \"$argv0 from ?to? ?evenOdd?\""
    exit 1
}
lassign $argv from to evenOdd
if {$argc < 3} {set evenOdd lucky}
if {$argc < 2} {set to ,}
if {![string is integer -strict $from] || $from < 1} {
    puts stderr "\"from\" must be positive integer"
    exit 1
} elseif {$to ne "," && (![string is integer -strict $to] || $to == 0)} {
    puts stderr "\"to\" must be positive integer or comma"
    exit 1
} elseif {[set evenOdd [string tolower $evenOdd]] ni {lucky evenlucky}} {
    puts stderr "\"evenOdd\" must be \"lucky\" or \"evenLucky\""
    exit 1
}
set l [lgen [expr {$evenOdd eq "evenlucky"}]]
set evenOdd [lindex {"lucky" "even lucky"} [expr {$evenOdd eq "evenlucky"}]]
if {$to eq ","} {
    puts "$from'th $evenOdd number = [collectIndices $l [incr from -1] $from]"
} elseif {$to < 0} {
    set to [expr {-$to}]
    puts "all $evenOdd numbers from $from to $to: [join [collectValues $l $from $to] ,]"
} else {
    puts "$from'th to $to'th $evenOdd numbers: [join [collectIndices $l [incr from -1] [incr to -1]] ,]"
}

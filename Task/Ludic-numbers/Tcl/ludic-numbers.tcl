package require Tcl 8.6

proc ludic n {
    global ludicList ludicGenerator
    for {} {[llength $ludicList] <= $n} {lappend ludicList $i} {
	set i [$ludicGenerator]
	set ludicGenerator [coroutine L_$i apply {{gen k} {
	    yield [info coroutine]
	    while true {
		set val [$gen]
		if {[incr i] == $k} {set i 0} else {yield $val}
	    }
	}} $ludicGenerator $i]
    }
    return [lindex $ludicList $n]
}
# Bootstrap the generator sequence
set ludicList [list 1]
set ludicGenerator [coroutine L_1 apply {{} {
    set n 1
    yield [info coroutine]
    while true {yield [incr n]}
}}]

# Default of 1000 is not enough
interp recursionlimit {} 5000

for {set i 0;set l {}} {$i < 25} {incr i} {lappend l [ludic $i]}
puts "first25: [join $l ,]"

for {set i 0} {[ludic $i] <= 1000} {incr i} {}
puts "below=1000: $i"

for {set i 1999;set l {}} {$i < 2005} {incr i} {lappend l [ludic $i]}
puts "2000-2005: [join $l ,]"

for {set i 0} {[ludic $i] < 256} {incr i} {set isl([ludic $i]) $i}
for {set i 1;set l {}} {$i < 250} {incr i} {
    if {[info exists isl($i)] && [info exists isl([expr {$i+2}])] && [info exists isl([expr {$i+6}])]} {
	lappend l ($i,[expr {$i+2}],[expr {$i+6}])
    }
}
puts "triplets: [join $l ,]"

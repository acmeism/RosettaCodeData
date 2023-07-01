proc sum_to_100 {} {
    for {set i 0} {$i <= 13121} {incr i} {
	set i3 [format %09d [dec2base 3 $i]]
	set form ""
	set subs {"" - +}
	foreach a [split $i3 ""] b [split 123456789 ""] {
	    append form [lindex $subs $a] $b
	}
	lappend R([expr $form]) $form
    }
    puts "solutions for sum=100:\n[join [lsort $R(100)] \n]"
    set max -1
    foreach key [array names R] {
	if {[llength $R($key)] > $max} {
	    set max [llength $R($key)]
	    set maxkey $key
	}
    }
    puts "max solutions: $max for $maxkey"
    for {set i 0} {$i <= 123456789} {incr i} {
	if ![info exists R($i)] {
	    puts "first unsolvable: $i"
	    break
	}
    }
    puts "highest 10:\n[lrange [lsort -integer -decr [array names R]] 0 9]"
}
proc dec2base {base dec} {
    set res ""
    while {$dec > 0} {
	set res [expr $dec%$base]$res
	set dec [expr $dec/$base]
    }
    if {$res eq ""} {set res 0}
    return $res
}
sum_to_100

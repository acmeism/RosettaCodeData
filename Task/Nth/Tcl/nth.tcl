proc ordinal {n} {
    if {$n%100<10 || $n%100>20} {
	set suff [lindex {th st nd rd th th th th th th} [expr {$n % 10}]]
    } else {
	set suff th
    }
    return "$n'$suff"
}

foreach start {0 250 1000} {
    for {set n $start; set l {}} {$n<=$start+25} {incr n} {
	lappend l [ordinal $n]
    }
    puts $l
}

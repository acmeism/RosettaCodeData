proc isNarcissistic {n} {
    set m [string length $n]
    for {set t 0; set N $n} {$N} {set N [expr {$N / 10}]} {
	incr t [expr {($N%10) ** $m}]
    }
    return [expr {$n == $t}]
}

proc firstNarcissists {target} {
    for {set n 0; set count 0} {$count < $target} {incr n} {
	if {[isNarcissistic $n]} {
	    incr count
	    lappend narcissists $n
	}
    }
    return $narcissists
}

puts [join [firstNarcissists 25] ","]

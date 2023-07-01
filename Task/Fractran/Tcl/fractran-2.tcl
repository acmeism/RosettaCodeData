oo::objdefine $ft method pow2 {n} {
    set co [coroutine [incr nco] my Generate 2]
    set pows {}
    while {[llength $pows] < $n} {
	set item [$co]
	if {($item & ($item-1)) == 0} {
	    lappend pows $item
	}
    }
    return $pows
}
puts [$ft pow2 10]

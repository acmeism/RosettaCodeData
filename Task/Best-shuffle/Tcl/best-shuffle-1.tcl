package require Tcl 8.5
package require struct::list

# Simple metric function; assumes non-empty lists
proc count {l1 l2} {
    foreach a $l1 b $l2 {incr total [string equal $a $b]}
    return $total
}
# Find the best shuffling of the string
proc bestshuffle {str} {
    set origin [split $str ""]
    set best $origin
    set score [llength $origin]
    struct::list foreachperm p $origin {
	if {$score > [set score [tcl::mathfunc::min $score [count $origin $p]]]} {
	    set best $p
	}
    }
    set best [join $best ""]
    return "$str,$best,($score)"
}

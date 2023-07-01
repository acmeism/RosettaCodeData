# Just compute the denominator terms, as the numerators are always 1
proc egyptian {num denom} {
    set result {}
    while {$num} {
	# Compute ceil($denom/$num) without floating point inaccuracy
	set term [expr {$denom / $num + ($denom/$num*$num < $denom)}]
	lappend result $term
	set num [expr {-$denom % $num}]
	set denom [expr {$denom * $term}]
    }
    return $result
}

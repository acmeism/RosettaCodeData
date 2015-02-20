proc uniform {limit} {
    set bits [expr {ceil(log($limit)/log(2))+10}]
    for {set b [set r 0]} {$b < $bits} {incr b 16} {
	incr r [expr {2**$b * int(rand() * 2**16)}]
    }
    return [expr {$r % $limit}]
}

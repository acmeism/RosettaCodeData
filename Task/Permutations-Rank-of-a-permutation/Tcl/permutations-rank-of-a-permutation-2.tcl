proc factorial {n} {
    for {set result 1; set i 2} {$i <= $n} {incr i} {
	set result [expr {$result * $i}]
    }
    return $result
}

set items1 [lrepeat 4 ""]
set rMax1 [factorial [llength $items1]]
for {set rank 0} {$rank < $rMax1} {incr rank} {
    computePermutation items1 $rank
    puts [format "%3d: \[%s\] = %d" \
	    $rank [join $items1 ", "] [computeRank $items1]]
}
puts ""
set items2 [lrepeat 21 ""]
set rMax2 [factorial [llength $items2]]
foreach _ {1 2 3 4} {
    # Note that we're casting to (potential) bignum, so entier() not int()
    set rank [expr {entier(rand() * $rMax2)}]
    computePermutation items2 $rank
    puts [format "%20lld: \[%s\] = %lld" \
	    $rank [join $items2 ", "] [computeRank $items2]]
}

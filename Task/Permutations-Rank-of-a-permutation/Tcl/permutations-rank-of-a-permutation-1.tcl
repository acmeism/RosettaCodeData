# A functional swap routine
proc swap {v idx1 idx2} {
    lset v $idx2 [lindex $v $idx1][lset v $idx1 [lindex $v $idx2];subst ""]
}

# Fill the integer array <vec> with the permutation at rank <rank>
proc computePermutation {vecName rank} {
    upvar 1 $vecName vec
    if {![info exist vec] || ![llength $vec]} return
    set N [llength $vec]
    for {set n 0} {$n < $N} {incr n} {lset vec $n $n}
    for {set n $N} {$n>=1} {incr n -1} {
	set r [expr {$rank % $n}]
	set rank [expr {$rank / $n}]
	set vec [swap $vec $r [expr {$n-1}]]
    }
}

# Return the rank of the current permutation.
proc computeRank {vec} {
    if {![llength $vec]} return
    set inv [lrepeat [llength $vec] 0]
    set i -1
    foreach v $vec {lset inv $v [incr i]}
    # First argument is lambda term
    set mrRank1 {{f n vec inv} {
	if {$n < 2} {return 0}
	set s [lindex $vec [set n1 [expr {$n - 1}]]]
	set vec [swap $vec $n1 [lindex $inv $n1]]
	set inv [swap $inv $s $n1]
	return [expr {$s + $n * [apply $f $f $n1 $vec $inv]}]
    }}
    return [apply $mrRank1 $mrRank1 [llength $vec] $vec $inv]
}

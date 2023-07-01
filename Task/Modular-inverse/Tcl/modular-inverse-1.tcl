proc gcdExt {a b} {
    if {$b == 0} {
	return [list 1 0 $a]
    }
    set q [expr {$a / $b}]
    set r [expr {$a % $b}]
    lassign [gcdExt $b $r] s t g
    return [list $t [expr {$s - $q*$t}] $g]
}
proc modInv {a m} {
    lassign [gcdExt $a $m] i -> g
    if {$g != 1} {
	return -code error "no inverse exists of $a %! $m"
    }
    while {$i < 0} {incr i $m}
    return $i
}

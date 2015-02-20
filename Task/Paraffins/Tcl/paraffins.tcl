package require Tcl 8.5

set maxN 200
set rooted [lrepeat $maxN 0]
lset rooted 0 1; lset rooted 1 1
set unrooted $rooted

proc choose {m k} {
    if {$k == 1} {
	return $m
    }
    for {set r $m; set i 1} {$i < $k} {incr i} {
	set r [expr {$r * ($m+$i) / ($i+1)}]
    }
    return $r
}

proc tree {br n cnt sum l} {
    global maxN rooted unrooted
    for {set b [expr {$br+1}]} {$b <= 4} {incr b} {
	set s [expr {$sum + ($b-$br) * $n}]
	if {$s >= $maxN} return
	set c [expr {[choose [lindex $rooted $n] [expr {$b-$br}]] * $cnt}]
	if {$l*2 < $s} {
	    lset unrooted $s [expr {[lindex $unrooted $s] + $c}]
	}
	if {$b == 4} return
	lset rooted $s [expr {[lindex $rooted $s] + $c}]
	for {set m $n} {[incr m -1]} {} {
	    tree $b $m $c $s $l
	}
    }
}

proc bicenter {s} {
    if {$s & 1} return
    global unrooted rooted
    set r [lindex $rooted [expr {$s/2}]]
    lset unrooted $s [expr {[lindex $unrooted $s] + $r*($r+1)/2}]
}

for {set n 1} {$n < $maxN} {incr n} {
    tree 0 $n 1 1 $n
    bicenter $n
    puts "${n}: [lindex $unrooted $n]"
}

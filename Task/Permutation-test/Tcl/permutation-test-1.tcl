package require Tcl 8.5

# Difference of means; note that the first list must be the concatenation of
# the two lists (because this is cheaper to work with).
proc statistic {AB A} {
    set sumAB [tcl::mathop::+ {*}$AB]
    set sumA [tcl::mathop::+ {*}$A]
    expr {
	$sumA / double([llength $A]) -
	($sumAB - $sumA) / double([llength $AB] - [llength $A])
    }
}

# Selects all k-sized combinations from a list.
proc selectCombinationsFrom {k l} {
    if {$k == 0} {return {}} elseif {$k == [llength $l]} {return [list $l]}
    set all {}
    set n [expr {[llength $l] - [incr k -1]}]
    for {set i 0} {$i < $n} {} {
        set first [lindex $l $i]
	incr i
        if {$k == 0} {
            lappend all $first
	} else {
	    foreach s [selectCombinationsFrom $k [lrange $l $i end]] {
		lappend all [list $first {*}$s]
	    }
        }
    }
    return $all
}

# Compute the permutation test value and its complement.
proc permutationTest {A B} {
    set whole [concat $A $B]
    set Tobs [statistic $whole $A]
    set undercount 0
    set overcount 0
    set count 0
    foreach perm [selectCombinationsFrom [llength $A] $whole] {
	set t [statistic $whole $perm]
	incr count
	if {$t <= $Tobs} {incr undercount} else {incr overcount}
    }
    set count [tcl::mathfunc::double $count]
    list [expr {$overcount / $count}] [expr {$undercount / $count}]
}

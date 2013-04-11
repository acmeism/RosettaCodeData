package require Tcl 8.5
namespace path {::tcl::mathfunc ::tcl::mathop}
proc sign x {expr {$x == 0 ? 0 : $x < 0 ? -1 : 1}}
proc norm vec {
    set s 0
    foreach x $vec {set s [expr {$s + $x**2}]}
    return [sqrt $s]
}
proc unitvec n {
    set v [lrepeat $n 0.0]
    lset v 0 1.0
    return $v
}
proc I n {
    set m [lrepeat $n [lrepeat $n 0.0]]
    for {set i 0} {$i < $n} {incr i} {lset m $i $i 1.0}
    return $m
}

proc arrayEmbed {A B row col} {
    # $A will be copied automatically; Tcl values are copy-on-write
    lassign [size $B] mb nb
    for {set i 0} {$i < $mb} {incr i} {
	for {set j 0} {$j < $nb} {incr j} {
	    lset A [expr {$row + $i}] [expr {$col + $j}] [lindex $B $i $j]
	}
    }
    return $A
}

# Unlike the Common Lisp version, here we use a specialist subcolumn
# extraction function: like that, there's a lot less intermediate memory allocation
# and the code is actually clearer.
proc subcolumn {A size column} {
    for {set i $column} {$i < $size} {incr i} {lappend x [lindex $A $i $column]}
    return $x
}

proc householder A {
    lassign [size $A] m
    set U [m+ $A [.* [unitvec $m] [expr {[norm $A] * [sign [lindex $A 0 0]]}]]]
    set V [./ $U [lindex $U 0 0]]
    set beta [expr {2.0 / [lindex [matrix_multiply [transpose $V] $V] 0 0]}]
    return [m- [I $m] [.* [matrix_multiply $V [transpose $V]] $beta]]
}

proc qrDecompose A {
    lassign [size $A] m n
    set Q [I $m]
    for {set i 0} {$i < ($m==$n ? $n-1 : $n)} {incr i} {
	# Construct the Householder matrix
	set H [arrayEmbed [I $m] [householder [subcolumn $A $n $i]] $i $i]
	# Apply to build the decomposition
	set Q [matrix_multiply $Q $H]
	set A [matrix_multiply $H $A]
    }
    return [list $Q $A]
}

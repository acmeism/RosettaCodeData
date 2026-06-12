# Continued fraction addition chains, as described in "Efficient computation
# of addition chains" by F. Bergeron, J. Berstel, and S. Brlek, published in
# Journal de théorie des nombres de Bordeaux, 6 no. 1 (1994), p. 21-38,
# accessed at http://www.numdam.org/item?id=JTNB_1994__6_1_21_0.
#
# Uses the dichotomic strategy, which produces good results with simpler
# coding than for a pluggable non-deterministic strategy.

package require Tcl 8.5
namespace path {::tcl::mathop ::tcl::mathfunc}

proc minchain {n} {
    if {!($n & ($n-1))} {
	for {set i 1} {$i <= $n} {incr i $i} {lappend c $i}
	return $c
    } elseif {$n == 3} {
	return {1 2 3}
    }
    return [chain $n [expr {$n >> int(ceil(floor(log($n)/log(2))/2))}]]
}
proc chain {n1 n2} {
    set q [expr {$n1 / $n2}]
    set r [expr {$n1 % $n2}]
    if {$r == 0} {
	return [chain.* [minchain $n2] [minchain $q]]
    } else {
	return [chain.+ [chain.* [chain $n2 $r] [minchain $q]] $r]
    }
}
proc chain.+ {ns k} {
    return [lappend ns [expr {[lindex $ns end] + $k}]]
}
proc chain.* {ns ms} {
    set n_k [lindex $ns end]
    foreach m_i $ms {
	if {$m_i==1} continue
	lappend ns [expr {$n_k * $m_i}]
    }
    return $ns
}

# Generate a lambda term to do exponentiation with a given multiplier command.
# Works by extracting information from the addition chain; the lambda term
# generated is minimal
proc makeExponentiationLambda {n mulfunc} {
    set chain [minchain $n]
    set cmd {set a0}
    set idxes 0
    foreach c0 [lrange $chain 0 end-1] c1 [lrange $chain 1 end] {
	lappend idxes [lsearch $chain [expr {$c1 - $c0}]]
    }
    for {set i 1} {$i<[llength $chain]} {incr i} {
	set cmd "$mulfunc \[$cmd\] \$a[lindex $idxes $i]"
	if {$i in $idxes} {
	    set cmd "set a$i \[$cmd\]"
	}
    }
    list a0 $cmd
}

# Demonstrating application of problem to matrix exponentiation
proc count_mult {a b} {incr ::countMult;matrix_multiply $a $b}
set m 31415
set n 27182
set mn [expr {$m*$n}]
set pow_m [makeExponentiationLambda $m count_mult]
set pow_n [makeExponentiationLambda $n count_mult]
set pow_mn [makeExponentiationLambda $mn count_mult]

set rh [expr {sqrt(0.5)}]
set mrh [expr {-$rh}]
set A [subst {
    {$rh 0 $rh 0 0 0}
    {0 $rh 0 $rh 0 0}
    {0 $rh 0 $mrh 0 0}
    {$mrh 0 $rh 0 0 0}
    {0 0 0 0 0 1}
    {0 0 0 0 1 0}
}]
puts "A**$m"; set countMult 0
print_matrix [apply $pow_m $A] %6.3f
puts "$countMult matrix multiplies"
puts "A**$n"; set countMult 0
print_matrix [apply $pow_n $A] %6.3f
puts "$countMult matrix multiplies"
puts "A**$mn"; set countMult 0
print_matrix [apply $pow_mn $A] %6.3f
puts "$countMult matrix multiplies"

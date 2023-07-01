package require Tcl 8.5

# Algorithm from http://introcs.cs.princeton.edu/java/78crypto/ModExp.java.html
# but Tcl has arbitrary-width integers and an exponentiation operator, which
# helps simplify the code.
proc tcl::mathfunc::modexp {a b n} {
    if {$b == 0} {return 1}
    set c [expr {modexp($a, $b / 2, $n)**2 % $n}]
    if {$b & 1} {
	set c [expr {($c * $a) % $n}]
    }
    return $c
}

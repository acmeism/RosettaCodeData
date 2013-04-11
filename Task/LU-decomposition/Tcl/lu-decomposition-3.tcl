# This does the decomposition and prints it out nicely
proc demo {A} {
    lassign [matrix::luDecompose $A] L U P
    foreach v {A L U P} {
	upvar 0 $v matrix
	puts "${v}:"
	matrix::print $matrix %.5g
	if {$v ne "P"} {puts "---------------------------------"}
    }
}
demo {{1 3 5} {2 4 7} {1 1 0}}
puts "================================="
demo {{11 9 24 2} {1 5 2 6} {3 17 18 1} {2 5 7 1}}

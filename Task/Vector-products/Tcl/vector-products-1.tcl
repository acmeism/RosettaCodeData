proc dot {A B} {
    lassign $A a1 a2 a3
    lassign $B b1 b2 b3
    expr {$a1*$b1 + $a2*$b2 + $a3*$b3}
}
proc cross {A B} {
    lassign $A a1 a2 a3
    lassign $B b1 b2 b3
    list [expr {$a2*$b3 - $a3*$b2}] \
	 [expr {$a3*$b1 - $a1*$b3}] \
	 [expr {$a1*$b2 - $a2*$b1}]
}
proc scalarTriple {A B C} {
    dot $A [cross $B $C]
}
proc vectorTriple {A B C} {
    cross $A [cross $B $C]
}

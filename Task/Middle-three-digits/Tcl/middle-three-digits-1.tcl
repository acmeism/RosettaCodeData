proc middleThree n {
    if {$n < 0} {
	set n [expr {-$n}]
    }
    set idx [expr {[string length $n] - 2}]
    if {$idx % 2 == 0} {
	error "no middle three digits: input is of even length"
    }
    if {$idx < 1} {
	error "no middle three digits: insufficient digits"
    }
    set idx [expr {$idx / 2}]
    string range $n $idx [expr {$idx+2}]
}

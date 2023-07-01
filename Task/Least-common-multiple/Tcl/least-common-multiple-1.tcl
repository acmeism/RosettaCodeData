proc lcm {p q} {
    set m [expr {$p * $q}]
    if {!$m} {return 0}
    while 1 {
	set p [expr {$p % $q}]
	if {!$p} {return [expr {$m / $q}]}
	set q [expr {$q % $p}]
	if {!$q} {return [expr {$m / $p}]}
    }
}

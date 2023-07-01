proc fibs n {
    for {set a 1;set b [set i 0]} {$i < $n} {incr i} {
	lappend result [set b [expr {$a + [set a $b]}]]
    }
    return $result
}
benfordTest [fibs 1000]

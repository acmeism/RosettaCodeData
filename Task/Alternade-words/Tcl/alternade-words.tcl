set unixdict [dict create]
foreach word [read [open unixdict.txt]] {
	dict set unixdict $word {}
}

proc is_alt_word word {
	global unixdict
	for {set i 0} {$i < [string length $word]} {incr i} {
		append [expr {$i % 2 ? "odd" : "even"}] [string index $word $i]
	}
	if {[dict exists $unixdict $even] && [dict exists $unixdict $odd]} {
		return [list $even $odd]
	}
}

foreach word [dict keys $unixdict] {
	if {[string length $word] >= 6 && [set oddeven [is_alt_word $word]] ne ""} {
		puts "$word $oddeven"
	}
}

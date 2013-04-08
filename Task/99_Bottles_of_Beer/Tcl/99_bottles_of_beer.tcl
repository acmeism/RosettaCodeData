set s "s"; set ob "of beer"; set otw "on the wall"; set more "Take one down and pass it around"
for {set n 100} {$n ne "No more"} {} {
	switch -- [incr n -1] {
		1 {set s ""}
		0 {set s "s"; set n "No more"; set more "Go to the store and buy some more"}
	}
	lappend verse ". $n bottle$s $ob $otw.\n"
	lappend verse "\n$n bottle$s $ob $otw, [string tolower $n] bottle$s $ob.\n$more"
}
puts -nonewline [join [lreplace $verse 0 0] ""][lindex $verse 0]

proc is_abc_word word {
	regexp {^[^bc]*a[^c]*b.*c} $word
}

set res [lmap w [read [open unixdict.txt]] {
	if {[is_abc_word $w]} {set w} else continue
}]

puts "Found [llength $res] words:"
puts [join $res \n]

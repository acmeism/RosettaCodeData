set f "non-existent-file.txt"

try {
    puts "try begin"

    set fd [open $f "r" ]

    set contents [read $fd]

    puts "try end"

} on error { results options } {
    puts stderr "results: $results"

    foreach {opt val} $options {
	puts stderr "options:\t$opt $val"
	
    }
}
puts "after try block"

if {[info exists contents] } {
    puts "$contents"
} else {
    puts stderr "no contents read"
}

# Print the first 10 terms of the Van der Corput sequence
for {set i 1} {$i <= 10} {incr i} {
    puts "vanDerCorput($i) = [digitReverse $i]"
}

# In other bases
foreach base {3 4 5} {
    set seq {}
    for {set i 1} {$i <= 10} {incr i} {
	lappend seq [format %.5f [digitReverse $i $base]]
    }
    puts "${base}: [join $seq {, }]"
}

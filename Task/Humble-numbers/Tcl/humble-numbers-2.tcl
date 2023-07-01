proc task2 {nmax} {
    puts "Distribution of digit length for the first $nmax humble numbers"
    set nHumble 0
    for {set i 1} {$nHumble < $nmax} {incr i} {
	if {[humble? $i]} {
	    incr nHumble
	    incr N([string length $i])
	}
    }
    parray N
}
task2 4096

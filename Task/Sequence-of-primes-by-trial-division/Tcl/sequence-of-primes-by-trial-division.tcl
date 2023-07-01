set primes {}
proc havePrime n {
    global primes
    foreach p $primes {
	# Do the test-by-trial-division
	if {$n/$p*$p == $n} {return false}
    }
    return true
}
for {set n 2} {$n < 100} {incr n} {
    if {[havePrime $n]} {
	lappend primes $n
	puts -nonewline "$n "
    }
}
puts ""

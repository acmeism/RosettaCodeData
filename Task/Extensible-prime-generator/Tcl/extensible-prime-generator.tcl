package require Tcl 8.6

# An iterative version of the Sieve of Eratosthenes.
# Effective limit is the size of memory.
coroutine primes apply {{} {
    yield
    while 1 {yield [coroutine primes_[incr p] apply {{} {
	yield [info coroutine]
	set plist {}
	for {set n 2} true {incr n} {
	    set found 0
	    foreach p $plist {
		if {$n%$p==0} {
		    set found 1
		    break
		}
	    }
	    if {!$found} {
		lappend plist $n
		yield $n
	    }
	}
    }}]}
}}

set p [primes]
for {set primes {}} {[llength $primes] < 20} {} {
    lappend primes [$p]
}
puts 1st20=[join $primes ,]
rename $p {}

set p [primes]
for {set primes {}} {[set n [$p]] <= 150} {} {
    if {$n >= 100 && $n <= 150} {
	lappend primes $n
    }
}
puts 100-150=[join $primes ,]
rename $p {}

set p [primes]
for {set count 0} {[set n [$p]] <= 8000} {} {
    incr count [expr {$n>=7700 && $n<=8000}]
}
puts count7700-8000=$count
rename $p {}

set p [primes]
for {set count 0} {$count < 10000} {incr count} {
    set prime [$p]
}
puts prime10000=$prime
rename $p {}

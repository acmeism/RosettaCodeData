namespace import ::tcl::mathop::*
package require math::numtheory 1.1.1; # Buggy before tcllib-1.20

proc fermat n {
	+ [** 2 [** 2 $n]] 1
}


for {set i 0} {$i < 10} {incr i} {
	puts "F$i = [fermat $i]"
}

for {set i 1} {1} {incr i} {
	puts -nonewline "F$i... "
	flush stdout
	set F [fermat $i]
	set factors [math::numtheory::primeFactors $F]
	if {[llength $factors] == 1} {
		puts "is prime"
	} else {
		puts "factors: $factors"
	}
}

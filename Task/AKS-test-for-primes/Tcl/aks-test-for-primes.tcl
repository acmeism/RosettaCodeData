proc coeffs {p {signs 1}} {
    set clist 1
    for {set i 0} {$i < $p} {incr i} {
	set clist [lmap x [list 0 {*}$clist] y [list {*}$clist 0] {
	    expr {$x + $y}
	}]
    }
    if {$signs} {
	set s -1
	set clist [lmap c $clist {expr {[set s [expr {-$s}]] * $c}}]
    }
    return $clist
}
proc aksprime {p} {
    if {$p < 2} {
	return false
    }
    foreach c [coeffs $p 0] {
	if {$c == 1} continue
	if {$c % $p} {
	    return false
	}
    }
    return true
}

for {set i 0} {$i <= 7} {incr i} {
    puts -nonewline "(x-1)^$i ="
    set j $i
    foreach c [coeffs $i] {
	puts -nonewline [format " %+dx^%d" $c $j]
	incr j -1
    }
    puts ""
}

set sub35primes {}
for {set i 1} {$i < 35} {incr i} {
    if {[aksprime $i]} {
	lappend sub35primes $i
    }
}
puts "primes under 35: [join $sub35primes ,]"

set sub50primes {}
for {set i 1} {$i < 50} {incr i} {
    if {[aksprime $i]} {
	lappend sub50primes $i
    }
}
puts "primes under 50: [join $sub50primes ,]"

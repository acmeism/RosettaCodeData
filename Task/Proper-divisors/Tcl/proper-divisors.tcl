proc properDivisors {n} {
    if {$n == 1} return
    set divs 1
    for {set i 2} {$i*$i <= $n} {incr i} {
	if {!($n % $i)} {
	    lappend divs $i
	    if {$i*$i < $n} {
		lappend divs [expr {$n / $i}]
	    }
	}
    }
    return $divs
}

for {set i 1} {$i <= 10} {incr i} {
    puts "$i => {[join [lsort -int [properDivisors $i]] ,]}"
}
set maxI [set maxC 0]
for {set i 1} {$i <= 20000} {incr i} {
    set c [llength [properDivisors $i]]
    if {$c > $maxC} {
	set maxI $i
	set maxC $c
    }
}
puts "max: $maxI => (...$maxC…)"

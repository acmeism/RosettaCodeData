# Basic implementation
proc ids n {
    while {$n != 1 && $n != 89} {
	for {set m 0} {$n} {set n [expr {$n / 10}]} {
	    incr m [expr {($n%10)**2}]
	}
	set n $m
    }
    return $n
}

# Build the optimised version
set body {
    # Microoptimisation to avoid an unnecessary alloc in the loop
    for {set m 0} {$n} {set n [expr {"$n[unset n]" / 10}]} {
	incr m [expr {($n%10)**2}]
    }
}
set map 0
for {set i 1} {$i <= 729} {incr i} {
    lappend map [ids $i]
}
proc ids2 n [append body "return \[lindex [list $map] \$m\]"]

# Put this in a lambda context for a little extra speed.
apply {{} {
    set count 0
    for {set i 1} {$i <= 100000000} {incr i} {
	incr count [expr {[ids2 $i] == 89}]
    }
    puts $count
}}

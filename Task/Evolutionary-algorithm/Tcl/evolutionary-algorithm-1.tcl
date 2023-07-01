package require Tcl 8.5

# A function to select a random character from an argument string
proc tcl::mathfunc::randchar s {
    string index $s [expr {int([string length $s]*rand())}]
}

# Set up the initial variables
set target "METHINKS IT IS LIKE A WEASEL"
set charset "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
set parent [subst [regsub -all . $target {[expr {randchar($charset)}]}]]
set MaxMutateRate 0.91
set C 100

# Work with parent and target as lists of characters so iteration is more efficient
set target [split $target {}]
set parent [split $parent {}]

# Generate the fitness *ratio*
proc fitness s {
    global target
    set count 0
    foreach c1 $s c2 $target {
	if {$c1 eq $c2} {incr count}
    }
    return [expr {$count/double([llength $target])}]
}
# This generates the converse of the Python version; logically saner naming
proc mutateRate {parent} {
    expr {(1.0-[fitness $parent]) * $::MaxMutateRate}
}
proc mutate {rate} {
    global charset parent
    foreach c $parent {
	lappend result [expr {rand() <= $rate ? randchar($charset) : $c}]
    }
    return $result
}
proc que {} {
    global iterations parent
    puts [format "#%-4i, fitness %4.1f%%, '%s'" \
	    $iterations [expr {[fitness $parent]*100}] [join $parent {}]]
}

while {$parent ne $target} {
    set rate [mutateRate $parent]
    if {!([incr iterations] % 100)} que
    set copies [list [list $parent [fitness $parent]]]
    for {set i 0} {$i < $C} {incr i} {
	lappend copies [list [set copy [mutate $rate]] [fitness $copy]]
    }
    set parent [lindex [lsort -real -decreasing -index 1 $copies] 0 0]
}
puts ""
que

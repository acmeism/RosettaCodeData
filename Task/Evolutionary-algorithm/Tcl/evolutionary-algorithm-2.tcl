package require Tcl 8.5
proc tcl::mathfunc::randchar {} {
    # A function to select a random character
    set charset "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
    string index $charset [expr {int([string length $charset] * rand())}]
}
set target "METHINKS IT IS LIKE A WEASEL"
set initial [subst [regsub -all . $target {[expr randchar()]}]]
set MaxMutateRate 0.91
set C 100

# A place-wise equality function defined over two lists (assumed equal length)
proc fitnessByEquality {target s} {
    set count 0
    foreach c1 $s c2 $target {
	if {$c1 eq $c2} {incr count}
    }
    return [expr {$count / double([llength $target])}]
}
# Generate the fitness *ratio* by place-wise equality with the target string
interp alias  {} fitness  {} fitnessByEquality [split $target {}]

# This generates the converse of the Python version; logically saner naming
proc mutationRate {individual} {
    global MaxMutateRate
    expr {(1.0-[fitness $individual]) * $MaxMutateRate}
}

# Mutate a string at a particular rate (per character)
proc mutate {parent rate} {
    foreach c $parent {
	lappend child [expr {rand() <= $rate ? randchar() : $c}]
    }
    return $child
}

# Pretty printer
proc prettyPrint {iterations parent} {
    puts [format "#%-4i, fitness %5.1f%%, '%s'" $iterations \
	[expr {[fitness $parent]*100}] [join $parent {}]]
}

# The evolutionary algorithm itself
proc evolve {initialString} {
    global C

    # Work with the parent as a list; the operations are more efficient
    set parent [split $initialString {}]

    for {set iterations 0} {[fitness $parent] < 1} {incr iterations} {
	set rate [mutationRate $parent]

	if {$iterations % 100 == 0} {
	    prettyPrint $iterations $parent
	}

	set copies [list [list $parent [fitness $parent]]]
	for {set i 0} {$i < $C} {incr i} {
	    lappend copies [list \
		    [set copy [mutate $parent $rate]] [fitness $copy]]
	}
	set parent [lindex [lsort -real -decreasing -index 1 $copies] 0 0]
    }
    puts ""
    prettyPrint $iterations $parent

    return [join $parent {}]
}

evolve $initial

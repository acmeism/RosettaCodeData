package require Tcl 8.6
package require generator

# How to generate permutations with repetitions
generator define permutationsWithRepetitions {input n} {
    if {[llength $input] == 0 || $n < 1} {error "bad arguments"}
    if {![incr n -1]} {
	foreach el $input {
	    generator yield [list $el]
	}
    } else {
	foreach el $input {
	    set g [permutationsWithRepetitions $input $n]
	    while 1 {
		generator yield [list $el {*}[$g]]
	    }
	}
    }
}

# Demonstrate usage
generator foreach val [permutationsWithRepetitions {1 2 3} 2] {
    puts $val
}

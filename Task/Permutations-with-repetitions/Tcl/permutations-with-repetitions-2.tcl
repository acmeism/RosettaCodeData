package require Tcl 8.6

# Utility function to make procedures that define generators
proc generator {name arguments body} {
    set body [list try $body on ok {} {return -code break}]
    set lambda [list $arguments "yield \[info coroutine\];$body"]
    proc $name args "tailcall \
	coroutine gen_\[incr ::generate_ctr\] apply [list $lambda] {*}\$args"
}

# How to generate permutations with repetitions
generator permutationsWithRepetitions {input n} {
    if {[llength $input] == 0 || $n < 1} {error "bad arguments"}
    if {![incr n -1]} {
	foreach el $input {
	    yield [list $el]
	}
    } else {
	foreach el $input {
	    set g [permutationsWithRepetitions $input $n]
	    while 1 {
		yield [list $el {*}[$g]]
	    }
	}
    }
}

# Demonstrate usage
set g [permutationsWithRepetitions {1 2 3} 2]
while 1 {puts [$g]}

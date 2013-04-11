# Do the computation, getting back a dictionary that maps
# values to its results (itself an ordered dictionary)
set results [pooled::computation $computationCode prime::factors $values]

# Find the maximum minimum factor with sorting magic
set best [lindex [lsort -integer -stride 2 -index {1 0} $results] end-1]

# Print in human-readable form
proc renderFactors {factorDict} {
    dict for {factor times} $factorDict {
	lappend v {*}[lrepeat $times $factor]
    }
    return [join $v "*"]
}
puts "$best = [renderFactors [dict get $results $best]]"

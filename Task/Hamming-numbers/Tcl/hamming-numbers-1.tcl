package require Tcl 8.6

# Simple helper: Tcl-style list "map"
proc map {varName list script} {
    set l {}
    upvar 1 $varName v
    foreach v $list {lappend l [uplevel 1 $script]}
    return $l
}

# The core of a coroutine to compute the product of a hamming sequence.
#
# Tricky bit: we don't automatically advance to the next value, and instead
# wait to be told that the value has been consumed (i.e., is the result of
# the [yield] operation).
proc ham {key multiplier} {
    global hammingCache
    set i 0
    yield [info coroutine]
    # Cannot use [foreach]; that would take a snapshot of the list in
    # the hammingCache variable, so missing updates.
    while 1 {
	set n [expr {[lindex $hammingCache($key) $i] * $multiplier}]
	# If the number selected was ours, we advance to compute the next
	if {[yield $n] == $n} {
	    incr i
	}
    }
}

# This coroutine computes the hamming sequence given a list of multipliers.
# It uses the [ham] helper from above to generate indivdual multiplied
# sequences. The key into the cache is the list of multipliers.
#
# Note that it is advisable for the values to be all co-prime wrt each other.
proc hammingCore args {
    global hammingCache
    set hammingCache($args) 1
    set hammers [map x $args {coroutine ham$x,$args ham $args $x}]
    yield
    while 1 {
	set n [lindex $hammingCache($args) [incr i]-1]
	lappend hammingCache($args) \
	    [tcl::mathfunc::min {*}[map h $hammers {$h $n}]]
	yield $n
    }
}

# Assemble the pieces so as to compute the classic hamming sequence.
coroutine hamming hammingCore 2 3 5
# Print the first 20 values of the sequence
for {set i 1} {$i <= 20} {incr i} {
    puts [format "hamming\[%d\] = %d" $i [hamming]]
}
for {} {$i <= 1690} {incr i} {set h [hamming]}
puts "hamming{1690} = $h"
for {} {$i <= 1000000} {incr i} {set h [hamming]}
puts "hamming{1000000} = $h"

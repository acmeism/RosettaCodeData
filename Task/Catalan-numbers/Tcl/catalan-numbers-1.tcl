package require Tcl 8.5

# Memoization wrapper
proc memoize {function value generator} {
    variable memoize
    set key $function,$value
    if {![info exists memoize($key)]} {
	set memoize($key) [uplevel 1 $generator]
    }
    return $memoize($key)
}

# The simplest recursive definition
proc tcl::mathfunc::catalan n {
    if {[incr n 0] < 0} {error "must not be negative"}
    memoize catalan $n {expr {
	$n == 0 ? 1 : 2 * (2*$n - 1) * catalan($n - 1) / ($n + 1)
    }}
}

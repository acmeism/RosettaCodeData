package require Tcl 8.5
proc luhn digitString {
    if {[regexp {[^0-9]} $digitString]} {error "not a number"}
    set sum 0
    set flip 1
    foreach ch [lreverse [split $digitString {}]] {
	incr sum [lindex {
	    {0 1 2 3 4 5 6 7 8 9}
	    {0 2 4 6 8 1 3 5 7 9}
	} [expr {[incr flip] & 1}] $ch]
    }
    return [expr {($sum % 10) == 0}]
}

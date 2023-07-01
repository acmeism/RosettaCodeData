package require Tcl 8.5

set hofcon10k {1 1}
proc hofcon10k n {
    global hofcon10k
    if {$n < 1} {error "n must be at least 1"}
    if {$n <= [llength $hofcon10k]} {
	return [lindex $hofcon10k [expr {$n-1}]]
    }
    while {$n > [llength $hofcon10k]} {
	set i [lindex $hofcon10k end]
	set a [lindex $hofcon10k [expr {$i-1}]]
	# Don't use end-based indexing here; faster to compute manually
	set b [lindex $hofcon10k [expr {[llength $hofcon10k]-$i}]]
	lappend hofcon10k [set c [expr {$a + $b}]]
    }
    return $c
}

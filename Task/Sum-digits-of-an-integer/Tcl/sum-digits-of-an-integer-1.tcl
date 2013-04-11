proc sumDigits {num {base 10}} {
    set total 0
    foreach d [split $num ""] {
	if {[string is alpha $d]} {
	    set d [expr {[scan [string tolower $d] %c] - 87}]
	} elseif {![string is digit $d]} {
	    error "bad digit: $d"
	}
	if {$d >= $base} {
	    error "bad digit: $d"
	}
	incr total $d
    }
    return $total
}

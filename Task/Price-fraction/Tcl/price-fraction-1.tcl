# Used once to turn the table into a "nice" form
proc parseTable table {
    set map {}
    set LINE_RE {^ *>= *([0-9.]+) *< *([0-9.]+) *:= *([0-9.]+) *$}
    foreach line [split $table \n] {
	if {[string trim $line] eq ""} continue
	if {[regexp $LINE_RE $line -> min max target]} {
	    lappend map $min $max $target
	} else {
	    error "invalid table format: $line"
	}
    }
    return $map
}

# How to apply the "nice" table to a particular value
proc priceFraction {map value} {
    foreach {minimum maximum target} $map {
	if {$value >= $minimum && $value < $maximum} {return $target}
    }
    # Failed to map; return the input
    return $value
}

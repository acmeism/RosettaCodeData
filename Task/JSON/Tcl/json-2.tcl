package require Tcl 8.6

proc tcl2json value {
    # Guess the type of the value; deep *UNSUPPORTED* magic!
    regexp {^value is a (.*?) with a refcount} \
	[::tcl::unsupported::representation $value] -> type

    switch $type {
	string {
	    # Skip to the mapping code at the bottom
	}
	dict {
	    set result "{"
	    set pfx ""
	    dict for {k v} $value {
		append result $pfx [tcl2json $k] ": " [tcl2json $v]
		set pfx ", "
	    }
	    return [append result "}"]
	}
	list {
	    set result "\["
	    set pfx ""
	    foreach v $value {
		append result $pfx [tcl2json $v]
		set pfx ", "
	    }
	    return [append result "\]"]
	}
	int - double {
	    return [expr {$value}]
	}
	booleanString {
	    return [expr {$value ? "true" : "false"}]
	}
	default {
	    # Some other type; do some guessing...
	    if {$value eq "null"} {
		# Tcl has *no* null value at all; empty strings are semantically
		# different and absent variables aren't values. So cheat!
		return $value
	    } elseif {[string is integer -strict $value]} {
		return [expr {$value}]
	    } elseif {[string is double -strict $value]} {
		return [expr {$value}]
	    } elseif {[string is boolean -strict $value]} {
		return [expr {$value ? "true" : "false"}]
	    }
	}
    }

    # For simplicity, all "bad" characters are mapped to \u... substitutions
    set mapped [subst -novariables [regsub -all {[][\u0000-\u001f\\""]} \
	$value {[format "\\\\u%04x" [scan {& } %c]]}]]
    return "\"$mapped\""
}

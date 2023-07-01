package require Tcl 8.6

proc combine {cases1 cases2 {insert ""}} {
    set result {}
    foreach c1 $cases1 {
	foreach c2 $cases2 {
	    lappend result $c1$insert$c2
	}
    }
    return $result
}
proc expand {string *expvar} {
    upvar 1 ${*expvar} expanded
    set a {}
    set result {}
    set depth 0
    foreach token [regexp -all -inline {(?:[^\\{},]|\\.)+|[\\{},]} $string] {
	switch $token {
	    "," {
		if {$depth == 0} {
		    lappend result {*}[commatize $a]
		    set a {}
		    set expanded 1
		    continue
		}
	    }
	    "\{" {incr depth  1}
	    "\}" {incr depth -1}
	}
	append a $token
    }
    lappend result {*}[commatize $a]
    return $result
}
proc commatize {string} {
    set current {{}}
    set depth 0
    foreach token [regexp -all -inline {(?:[^\\{},]|\\.)+|[\\{},]} $string] {
	switch $token {
	    "\{" {
		if {[incr depth] == 1} {
		    set collect {}
		    continue
		}
	    }
	    "\}" {
		if {[incr depth -1] == 0} {
		    set foundComma 0
		    set exp [expand $collect foundComma]
		    if {!$foundComma} {
			set exp [lmap c [commatize $collect] {set c \{$c\}}]
		    }
		    set current [combine $current $exp]
		    continue
		} elseif {$depth < 0} {
		    set depth 0
		}
	    }
	}
	if {$depth} {
	    append collect $token
	} else {
	    set current [lmap s $current {set s $s$token}]
	}
    }
    if {$depth} {
	set current [combine $current [commatize $collect] "\{"]
    }
    return $current
}

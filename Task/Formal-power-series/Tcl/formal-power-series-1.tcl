package require TclOO

oo::class create PowerSeries {
    variable name
    constructor {{body {}} args} {
        # Use the body to adapt the methods of the _object_
	oo::objdefine [self] $body
        # Use the rest to configure variables in the object
	foreach {var val} $args {
	    set [my varname $var] $val
	}
        # Guess the name if not already set
	if {![info exists [my varname name]]} {
	    set name [namespace tail [self]]
	}
    }
    method name {} {
	return $name
    }
    method term i {
	return 0
    }
    method limit {} {
	return inf
    }

    # A pretty-printer, that prints the first $terms non-zero terms
    method print {terms} {
	set result "${name}(x) == "
	set limit [my limit]
	if {$limit == 0} {
	    # Special case
	    return $result[my term 0]
	}
	set tCount 0
	for {set i 0} {$tCount<$terms && $i<=$limit} {incr i} {
	    set t [my term $i]
	    if {$t == 0} continue
	    incr tCount
	    set t [format %.4g $t]
            if {$t eq "1" && $i != 0} {set t ""}
	    if {$i == 0} {
		append result "$t + "
	    } elseif {$i == 1} {
		append result "${t}x + "
	    } else {
		set p [string map {
		    0 \u2070 1 \u00b9 2 \u00b2 3 \u00b3 4 \u2074
		    5 \u2075 6 \u2076 7 \u2077 8 \u2078 9 \u2079
		} $i]
		append result "${t}x$p + "
	    }
	}
	return [string trimright $result "+ "]
    }

    # Evaluate (a prefix of) the series at a particular x
    # The terms parameter gives the number; 5 is enough for show
    method evaluate {x {terms 5}} {
	set result 0
	set limit [my limit]
	set tCount 0
	for {set i 0} {$tCount<$terms && $i<=$limit} {incr i} {
	    set t [my term $i]
	    if {$t == 0} continue
	    incr tCount
	    set result [expr {$result + $t * ($x ** $i)}]
	}
	return $result
    }

    # Operations to build new sequences from old ones
    method add {s} {
	PowerSeries new {
	    variable S1 S2
	    method limit {} {expr {max([$S1 limit],[$S2 limit])}}
	    method term i {
		set t1 [expr {$i>[$S1 limit] ? 0 : [$S1 term $i]}]
		set t2 [expr {$i>[$S2 limit] ? 0 : [$S2 term $i]}]
		expr {$t1 + $t2}
	    }
	} S1 [self] S2 $s name "$name+[$s name]"
    }
    method subtract {s} {
	PowerSeries new {
	    variable S1 S2
	    method limit {} {expr {max([$S1 limit],[$S2 limit])}}
	    method term i {
		set t1 [expr {$i>[$S1 limit] ? 0 : [$S1 term $i]}]
		set t2 [expr {$i>[$S2 limit] ? 0 : [$S2 term $i]}]
		expr {$t1 - $t2}
	    }
	} S1 [self] S2 $s name "$name-[$s name]"
    }
    method integrate {{Name ""}} {
	if {$Name eq ""} {set Name "Integrate\[[my name]\]"}
	PowerSeries new {
	    variable S limit
	    method limit {} {
		if {[info exists limit]} {return $limit}
		try {
		    return [expr {[$S limit] + 1}]
		} on error {} {
		    # If the limit spirals out of control, it's infinite!
		    return [set limit inf]
		}
	    }
	    method term i {
		if {$i == 0} {return 0}
		set t [$S term [expr {$i-1}]]
		expr {$t / double($i)}
	    }
	} S [self] name $Name
    }
    method differentiate {{Name ""}} {
	if {$Name eq ""} {set Name "Differentiate\[[my name]\]"}
	PowerSeries new {
	    variable S
	    method limit {} {expr {[$S limit] ? [$S limit] - 1 : 0}}
	    method term  i  {expr {[incr i] * [$S term $i]}}
	} S [self] name $Name
    }
    # Special constructor for making constants
    self method constant n {
	PowerSeries new {
	    variable n
	    method limit {} {return 0}
	    method term i {return $n}
	} n $n name $n
    }
}

# Define the two power series in terms of each other
PowerSeries create cos ;# temporary dummy object...
rename [cos integrate "sin"] sin
cos destroy            ;# remove the dummy to make way for the real one...
rename [[PowerSeries constant 1] subtract [sin integrate]] cos

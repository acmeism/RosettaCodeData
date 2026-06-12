package require Tcl 8.6
proc name2num name {
    set words [regexp -all -inline {[a-z]+} [string tolower $name]]
    set tokens {
	"zero" 0 "one" 1 "two" 2 "three" 3 "four" 4 "five" 5 "six" 6 "seven" 7
	"eight" 8 "nine" 9 "ten" 10 "eleven" 11 "twelve" 12 "thirteen" 13
	"fourteen" 14 "fifteen" 15 "sixteen" 16 "seventeen" 17 "eighteen" 18
	"nineteen" 19 "twenty" 20 "thirty" 30 "forty" 40 "fifty" 50 "sixty" 60
	"seventy" 70 "eighty" 80 "ninety" 90 "hundred" 100 "thousand" 1000
	"million" 1000000 "billion" 1000000000 "trillion" 1000000000000
	"quadrillion" 1000000000000000 "qintillion" 1000000000000000000
    }
    set values {}
    set groups {}
    set previous -inf
    set sign 1
    foreach word $words {
	if {[dict exists $tokens $word]} {
	    set value [dict get $tokens $word]
	    if {$value < $previous} {
		# Check if we have to propagate backwards the "large" terms
		if {[set mult [lindex $values end]] > 99} {
		    for {set i [llength $groups]} {[incr i -1] >= 0} {} {
			if {[lindex $groups $i end] >= $mult} {
			    break
			}
			lset groups $i end+1 $mult
		    }
		}
		lappend groups $values
		set values {}
	    } elseif {$value < 100 && $previous < 100 && $previous >= 0} {
		# Special case: dates
		lappend groups [lappend values 100]
		set values {}
	    }
	    lappend values $value
	    set previous $value
	} elseif {$word eq "minus"} {
	    set sign -1
	}
    }
    lappend groups $values
    set groups [lmap prodgroup $groups {tcl::mathop::* {*}$prodgroup}]
    # Special case: dates
    if {[llength $groups] == 2} {
	if {[lmap g $groups {expr {$g < 100 && $g >= 10}}] eq {1 1}} {
	    lset groups 0 [expr {[lindex $groups 0] * 100}]
	}
    }
    return [expr {$sign * [tcl::mathop::+ {*}$groups]}]
}

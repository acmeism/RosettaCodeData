package require Tcl 8.5
# Gödel number generator
proc goedel s {
    set primes {
	2 3 5 7 11 13 17 19 23 29 31 37 41
	43 47 53 59 61 67 71 73 79 83 89 97 101
    }
    set n 1
    foreach c [split [string toupper $s] ""] {
	if {![string is alpha $c]} continue
	set n [expr {$n * [lindex $primes [expr {[scan $c %c] - 65}]]}]
    }
    return $n
}
# Calculates the pairs of states
proc groupStates {stateList} {
    set stateList [lsort -unique $stateList]
    foreach state1 $stateList {
	foreach state2 $stateList {
	    if {$state1 >= $state2} continue
	    dict lappend group [goedel $state1$state2] [list $state1 $state2]
	}
    }
    foreach g [dict values $group] {
	if {[llength $g] > 1} {
	    foreach p1 $g {
		foreach p2 $g {
		    if {$p1 < $p2 && [unshared $p1 $p2]} {
			lappend result [list $p1 $p2]
		    }
		}
	    }
	}
    }
    return $result
}
proc unshared args {
    foreach p $args {
	foreach a $p {incr s($a)}
    }
    expr {[array size s] == [llength $args]*2}
}
# Pretty printer for state name pair lists
proc printPairs {title groups} {
    foreach group $groups {
	puts "$title Group #[incr count]"
	foreach statePair $group {
	    puts "\t[join $statePair {, }]"
	}
    }
}

set realStates {
    "Alabama" "Alaska" "Arizona" "Arkansas" "California" "Colorado"
    "Connecticut" "Delaware" "Florida" "Georgia" "Hawaii" "Idaho" "Illinois"
    "Indiana" "Iowa" "Kansas" "Kentucky" "Louisiana" "Maine" "Maryland"
    "Massachusetts" "Michigan" "Minnesota" "Mississippi" "Missouri" "Montana"
    "Nebraska" "Nevada" "New Hampshire" "New Jersey" "New Mexico" "New York"
    "North Carolina" "North Dakota" "Ohio" "Oklahoma" "Oregon" "Pennsylvania"
    "Rhode Island" "South Carolina" "South Dakota" "Tennessee" "Texas" "Utah"
    "Vermont" "Virginia" "Washington" "West Virginia" "Wisconsin" "Wyoming"
}
printPairs "Real States" [groupStates $realStates]
set falseStates {
    "New Kory" "Wen Kory" "York New" "Kory New" "New Kory"
}
printPairs "Real and False States" [groupStates [concat $realStates $falseStates]]

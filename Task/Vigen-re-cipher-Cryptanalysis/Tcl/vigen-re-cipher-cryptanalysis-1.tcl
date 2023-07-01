package require Tcl 8.6

oo::class create VigenereAnalyzer {
    variable letterFrequencies sortedTargets
    constructor {{frequencies {
 	0.08167 0.01492 0.02782 0.04253 0.12702 0.02228 0.02015
	0.06094 0.06966 0.00153 0.00772 0.04025 0.02406 0.06749
	0.07507 0.01929 0.00095 0.05987 0.06327 0.09056 0.02758
	0.00978 0.02360 0.00150 0.01974 0.00074
    }}} {
	set letterFrequencies $frequencies
	set sortedTargets [lsort -real $frequencies]
	if {[llength $frequencies] != 26} {
	    error "wrong length of frequency table"
	}
    }

    ### Utility methods
    # Find the value of $idxvar in the range [$from..$to) that maximizes the value
    # in $scorevar (which is computed by evaluating $body)
    method Best {idxvar from to scorevar body} {
	upvar 1 $idxvar i $scorevar s
	set bestI $from
	for {set i $from} {$i < $to} {incr i} {
	    uplevel 1 $body
	    if {![info exist bestS] || $bestS < $s} {
		set bestI $i
		set bestS $s
	    }
	}
	return $bestI
    }
    # Simple list map
    method Map {var list body} {
	upvar 1 $var v
	set result {}
	foreach v $list {lappend result [uplevel 1 $body]}
	return $result
    }
    # Simple partition of $list into $groups groups; thus, the partition of
    # {a b c d e f} into 3 produces {a d} {b e} {c f}
    method Partition {list groups} {
	set i 0
	foreach val $list {
	    dict lappend result $i $val
	    if {[incr i] >= $groups} {
		set i 0
	    }
	}
	return [dict values $result]
    }

    ### Helper methods
    # Get the actual counts of different types of characters in the given list
    method Frequency cleaned {
	for {set i 0} {$i < 26} {incr i} {
	    dict set tbl $i 0
	}
	foreach ch $cleaned {
	    dict incr tbl [expr {[scan $ch %c] - 65}]
	}
	return $tbl
    }

    # Get the correlation factor of the characters in a given list with the
    # class-specified language frequency corpus
    method Correlation cleaned {
	set result 0.0
	set freq [lsort -integer [dict values [my Frequency $cleaned]]]
	foreach f $freq s $sortedTargets {
	    set result [expr {$result + $f * $s}]
	}
	return $result
    }

    # Compute an estimate for the key length
    method GetKeyLength {cleaned {required 20}} {
	# Assume that we need at least 20 characters per column to guess
	set bestLength [my Best i 2 [expr {[llength $cleaned] / $required}] corr {
	    set corr [expr {-0.5 * $i}]
	    foreach chars [my Partition $cleaned $i] {
		set corr [expr {$corr + [my Correlation $chars]}]
	    }
	}]
	if {$bestLength == 0} {
	    error "text is too short to analyze"
	}
	return $bestLength
    }

    # Compute the key from the given frequency tables and the class-specified
    # language frequency corpus
    method GetKeyFromFreqs freqs {
	foreach f $freqs {
	    set m [my Best i 0 26 corr {
		set corr 0.0
		foreach {ch count} $f {
		    set d [expr {($ch - $i) % 26}]
		    set corr [expr {$corr + $count*[lindex $letterFrequencies $d]}]
		}
	    }]
	    append key [format %c [expr {65 + $m}]]
	}
	return $key
    }

    ##### The main analyzer method #####
    method analyze input {
	# Turn the input into a clean letter sequence
	set cleaned [regexp -all -inline {[A-Z]} [string toupper $input]]
	# Get the (estimated) key length
	set bestLength [my GetKeyLength $cleaned]
	# Get the frequency mapping for the partitioned input text
	set freqs [my Map p [my Partition $cleaned $bestLength] {my Frequency $p}]
	# Get the key itself
	return [my GetKeyFromFreqs $freqs]
    }
}

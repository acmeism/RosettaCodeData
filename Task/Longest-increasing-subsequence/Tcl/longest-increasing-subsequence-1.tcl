package require Tcl 8.6

proc longestIncreasingSubsequence {sequence} {
    # Get the increasing subsequences (and their lengths)
    set subseq [list 1 [lindex $sequence 0]]
    foreach value $sequence {
	set max {}
	foreach {len item} $subseq {
	    if {[lindex $item end] < $value} {
		if {[llength [lappend item $value]] > [llength $max]} {
		    set max $item
		}
	    } elseif {![llength $max]} {
		set max [list $value]
	    }
	}
	lappend subseq [llength $max] $max
    }
    # Pick the longest subsequence; -stride requires Tcl 8.6
    return [lindex [lsort -stride 2 -index 0 $subseq] end]
}

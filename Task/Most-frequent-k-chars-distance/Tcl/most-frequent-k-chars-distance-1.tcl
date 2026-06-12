package require Tcl 8.6

proc MostFreqKHashing {inputString k} {
    foreach ch [split $inputString ""] {dict incr count $ch}
    join [lrange [lsort -stride 2 -index 1 -integer -decreasing $count] 0 [expr {$k*2-1}]] ""
}
proc MostFreqKSimilarity {hashStr1 hashStr2} {
    while {$hashStr2 ne ""} {
	regexp {^(.)(\d+)(.*)$} $hashStr2 -> ch n hashStr2
	set lookup($ch) $n
    }
    set similarity 0
    while {$hashStr1 ne ""} {
	regexp {^(.)(\d+)(.*)$} $hashStr1 -> ch n hashStr1
	if {[info exist lookup($ch)]} {
	    incr similarity $n
	    incr similarity $lookup($ch)
	}
    }
    return $similarity
}
proc MostFreqKSDF {inputStr1 inputStr2 k limit} {
    set h1 [MostFreqKHashing $inputStr1 $k]
    set h2 [MostFreqKHashing $inputStr2 $k]
    expr {$limit - [MostFreqKSimilarity $h1 $h2]}
}

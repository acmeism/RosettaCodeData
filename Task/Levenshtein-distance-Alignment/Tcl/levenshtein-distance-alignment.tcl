package require struct::list
proc levenshtein/align {a b} {
    lassign [struct::list longestCommonSubsequence [split $a ""] [split $b ""]]\
	    apos bpos
    set c ""
    set d ""
    set x0 [set y0 -1]
    set dx [set dy 0]
    foreach x $apos y $bpos {
	if {$x+$dx < $y+$dy} {
	    set n [expr {($y+$dy)-($x+$dx)}]
	    incr dx $n
	    append c [string repeat "-" $n]
	} elseif {$x+$dx > $y+$dy} {
	    set n [expr {($x+$dx)-($y+$dy)}]
	    incr dy $n
	    append d [string repeat "-" $n]
	}
	append c [string range $a $x0+1 $x]
	set x0 $x
	append d [string range $b $y0+1 $y]
	set y0 $y
    }
    append c [string range $a $x0+1 end]
    append d [string range $b $y0+1 end]
    set al [string length $a]
    set bl [string length $b]
    if {$al+$y0 < $bl+$x0} {
	append c [string repeat "-" [expr {$bl+$x0-$y0-$al}]]
    } elseif {$bl+$x0 < $al+$y0} {
	append d [string repeat "-" [expr {$al+$y0-$x0-$bl}]]
    }
    return $c\n$d
}

puts [levenshtein/align "rosettacode" "raisethysword"]

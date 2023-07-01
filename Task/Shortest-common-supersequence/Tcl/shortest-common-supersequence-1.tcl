proc scs {u v} {
    set lcs [lcs $u $v]
    set scs ""

    # Iterate over the characters until LCS processed
    for {set ui [set vi [set li 0]]} {$li<[string length $lcs]} {} {
	set uc [string index $u $ui]
	set vc [string index $v $vi]
	set lc [string index $lcs $li]
	if {$uc eq $lc} {
	    if {$vc eq $lc} {
		# Part of the LCS, so consume from all strings
		append scs $lc
		incr ui
		incr li
	    } else {
		# char of u = char of LCS, but char of LCS v doesn't so consume just that
		append scs $vc
	    }
	    incr vi
	} else {
	    # char of u != char of LCS, so consume just that
	    append scs $uc
	    incr ui
	}
    }

    # append remaining characters, which are not in common
    append scs [string range $u $ui end] [string range $v $vi end]
    return $scs
}

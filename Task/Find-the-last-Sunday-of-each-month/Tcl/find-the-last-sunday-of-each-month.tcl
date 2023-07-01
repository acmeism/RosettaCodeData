proc lastSundays {{year ""}} {
    if {$year eq ""} {
	set year [clock format [clock seconds] -gmt 1 -format "%Y"]
    }
    foreach month {2 3 4 5 6 7 8 9 10 11 12 13} {
	set d [clock add [clock scan "$month/1/$year" -gmt 1] -1 day]
	while {[clock format $d -gmt 1 -format "%u"] != 7} {
	    set d [clock add $d -1 day]
	}
	lappend result [clock format $d -gmt 1 -format "%Y-%m-%d"]
    }
    return $result
}
puts [join [lastSundays {*}$argv] "\n"]

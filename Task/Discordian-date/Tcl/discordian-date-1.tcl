package require Tcl 8.5
proc disdate {year month day} {
    # Get the day of the year
    set now [clock scan [format %02d-%02d-%04d $day $month $year] -format %d-%m-%Y]
    scan [clock format $now -format %j] %d doy

    # Handle leap years
    if {!($year%4) && (($year%100) || !($year%400))} {
	if {$doy == 60} {
	    return "St. Tib's Day, [expr {$year + 1166}] YOLD"
	} elseif {$doy > 60} {
	    incr doy -1
	}
    }

    # Main conversion to discordian format now that special cases are handled
    incr doy -1; # Allow div/mod to work right
    set season [lindex {Chaos Discord Confusion Bureaucracy {The Aftermath}} \
	    [expr {$doy / 73}]]
    set dos [expr {$doy % 73 + 1}]
    incr year 1166
    return "$season $dos, $year YOLD"
}

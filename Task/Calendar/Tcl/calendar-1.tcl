package require Tcl 8.5

# Produce information about the days in a month, without any assumptions about
# what those days actually are.
proc calMonthDays {timezone locale year month} {
    set days {}
    set moment [clock scan [format "%04d-%02d-00 12:00" $year $month] \
	    -timezone $timezone -locale $locale -format "%Y-%m-%d %H:%M"]
    while 1 {
	set moment [clock add $moment 1 day]
	lassign [clock format $moment -timezone $timezone -locale $locale \
		-format "%m %d %u"] m d dow
	if {[scan $m %d] != $month} {
	    return $days
	}
	lappend days $moment [scan $d %d] $dow
    }
}

proc calMonth {year month timezone locale} {
    set dow 0
    set line ""
    set lines {}
    foreach {t day dayofweek} [calMonthDays $timezone $locale $year $month] {
	if {![llength $lines]} {lappend lines $t}
	if {$dow > $dayofweek} {
	    lappend lines [string trimright $line]
	    set line ""
	    set dow 0
	}
	while {$dow < $dayofweek-1} {
	    append line "   "
	    incr dow
	}
	append line [format "%2d " $day]
	set dow $dayofweek
    }
    lappend lines [string trimright $line]
}

proc cal3Month {year month timezone locale} {
    # Extract the month data
    set d1 [lassign [calMonth $year $month $timezone $locale] t1]; incr month
    set d2 [lassign [calMonth $year $month $timezone $locale] t2]; incr month
    set d3 [lassign [calMonth $year $month $timezone $locale] t3]
    # Print the header line of month names
    foreach t [list $t1 $t2 $t3] {
	set m [clock format $t -timezone $timezone -locale $locale -format "%B"]
	set l [expr {10 + [string length $m]/2}]
	puts -nonewline [format "%-25s" [format "%*s" $l $m]]
    }
    puts ""
    # Print the month days
    foreach l1 $d1 l2 $d2 l3 $d3 {
	puts [format "%-25s%-25s%s" $l1 $l2 $l3]
    }
}

proc cal {{year ""} {timezone :localtime} {locale en}} {
    if {$year eq ""} {
	set year [clock format [clock seconds] -format %Y]
    }
    puts [format "%40s" "-- $year --"]
    foreach m {1 4 7 10} {
	puts ""
	cal3Month $year $m $timezone $locale
    }
}

proc snoopy {} {
    puts [format "%43s\n" {[Snoopy Picture]}]
}

snoopy
cal

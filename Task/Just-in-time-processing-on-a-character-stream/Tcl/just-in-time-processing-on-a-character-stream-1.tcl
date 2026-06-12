package require Tcl 8.6

oo::class create JustInTimeStreamExtract {
    variable map counter counters last
    constructor {{pageSeparator "\f"} {lineSeparator "\n"} {fieldSeparator "\t"}} {
	dict set map $pageSeparator NextPage
	dict set map $lineSeparator NextLine
	dict set map $fieldSeparator NextField
	set counter 1
	array set counters {page 0 line 0 field 0 char 0}
	set last ""
    }

    method emit {char} {
	puts -nonewline $char
	set last $char
    }
    method finished {} {
	if {$last ne "\n"} {
	    puts ""
	}
    }

    method stream {{channel stdin} {length 1}} {
	try {
	    while 1 {
		set str [read $channel $length]
		if {[eof $channel]} break
		foreach c [split $str ""] {
		    if {[dict exists $map $c]} {
			my [dict get $map $c]
		    } else {
			my NextChar $c
		    }
		}
	    }
	} trap STOP {} {
	    # Do nothing
	}
	my finished
    }

    method NextPage {} {
	incr counters(page)
	array set counters {line 0 field 0 char 0}
    }
    method NextLine {} {
	incr counters(line)
	array set counters {field 0 char 0}
    }
    method NextField {} {
	incr counters(field)
	set counters(char) 0
    }
    method NextChar {char} {
	incr counters(char)
	if {[my PrintThisOne?]} {
	    if {$char eq "!"} {
		throw STOP "stop character found"
	    }
	    incr counter
	    my emit $char
	    array set counters {page 0 line 0 field 0 char 0}
	}
    }

    method PrintThisOne? {} {
	tcl::mathop::== $counter $counters(page) $counters(line) $counters(field) $counters(char)
    }
}

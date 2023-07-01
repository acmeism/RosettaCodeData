# Model the data as nested lists, as that is a natural fit for Tcl
set basicRecords {
    {
	jsmith
	x
	1001
	1000
	{
	    {Joe Smith}
	    {Room 1007}
	    (234)555-8917
	    (234)555-0077
	    jsmith@rosettacode.org
	}
	/home/jsmith
	/bin/bash
    }
    {
	jdoe
	x
	1002
	1000
	{
	    {Jane Doe}
	    {Room 1004}
	    (234)555-8914
	    (234)555-0044
	    jdoe@rosettacode.org
	}
	/home/jsmith
	/bin/bash
    }
}
set addedRecords {
    {
	xyz
	x
	1003
	1000
	{
	    {X Yz}
	    {Room 1003}
	    (234)555-8913
	    (234)555-0033
	    xyz@rosettacode.org
	}
	/home/xyz
	/bin/bash
    }
}

proc printRecords {records fd} {
    fconfigure $fd -buffering none
    foreach record $records {
	lset record 4 [join [lindex $record 4] ","]
	puts -nonewline $fd [join $record ":"]\n
    }
}
proc readRecords fd {
    set result {}
    foreach line [split [read $fd] "\n"] {
	if {$line eq ""} continue
	set record [split $line ":"]
	# Special handling for GECOS
	lset record 4 [split [lindex $record 4] ","]
	lappend result $record
    }
    return $result
}

# Write basic set
set f [open ./passwd w]
printRecords $basicRecords $f
close $f

# Append the extra ones
# Use {WRONLY APPEND} on Tcl 8.4
set f [open ./passwd a]
printRecords $addedRecords $f
close $f

set f [open ./passwd]
set recs [readRecords $f]
close $f
puts "last record is for [lindex $recs end 0], named [lindex $recs end 4 0]"

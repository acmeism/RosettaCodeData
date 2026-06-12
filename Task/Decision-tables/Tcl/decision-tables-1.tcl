#!/usr/bin/env  tclsh

# decision table example
# ref - https://rosettacode.org/wiki/Decision_tables

# get input from user (cmdline)
proc ask_yn { prompt {auto_anser "N"} } {
    puts -nonewline "${prompt} ? "
    flush stdout
    set ans ""
    set valid 0

    while {! $valid} {

	# keyboard input
        gets stdin ans
        switch -nocase -glob $ans {
            Y* { set valid 1; set ans Y }
            N* { set valid 1; set ans N }
	        "" { set valid 1; set ans $auto_answer }
            default {}
        }
        if {!$valid} { puts "Choose either Y or N" }
    }

    return [expr $ans == Y]
} ;# ask_yn


# example printer troubleshooter
# ref - https://en.wikipedia.org/wiki/Decision_table

set problems {
    {printer prints}
    {red light flashes}
    {printer recognized}
}

# suggested solutions
set solutions {
    {check power cable}
    {check printer cable}
    {install printer software}
    {replace printer ink}
    {possible paper jam}
}

# decision table
# question (string) : recommendations index (list)
set matrix  {
    {NYN}  {1 2 3}
    {NYY}  {3 4}
    {NNN}  {0 1 2}
    {NNY}  {4}
    {YYN}  {2}
    {YYY}  {3}
    {YNN}  {2}
    {YNY}  {offon}
}

proc diagnose {Probs Sols Mtrx} {

    set ans {}
    set sol {}
    set n 1

    # ask questions
    foreach P $Probs {
	set q [ask_yn $P]
	    append ans [expr { $q ? Y : N}]
    }

    # find answer in matrix
    foreach {a rec} $Mtrx {
	    if {$a eq $ans} {set sol $rec}
    }

    if {$sol eq {} } {
	    puts "Unknown problem"
	return 1
    }

    # print solutions
    foreach s $sol {

	    if {$s eq {offon} } {
	        puts stdout "Have you tried turning it off and then on again?"
	        return 0
	    }
	
	    # print suggested solutions
	    set suggest [lindex $Sols $s]
	    puts stdout "${n}. ${suggest}"
	    incr n
    }
    return 0
}

set status [diagnose $problems $solutions $matrix]

return $status

#!/usr/bin/env  tclsh

# output middle 3 digits or error

# good integers
set good {123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345}

# bad integers
set bad {doggy 1 2 -1 -10 2002 -2002 0}

proc  middle_3 {num} {

    # error messages
    array set error {
	   notint {(not an integer)}
	   short {(number < 3 digits)}
	   even  {(even number of digits)}
	   zero {(zero length entry)}
  	   {unknown} {(unknown error)}
    }

    set err 0

    # must be integer
    if { ! [string is integer $num] } {
	   set err 1
	   set errstr $error(notint)
    }

    # work with positive val
    if { $num < 0 } { set num [expr {abs($num)} ] }

    # how many digits
    set dlen [string length $num]

    if {$dlen < 3}      {
	   set err 1
	   set errstr  $error(short)
    }

    if {$dlen % 2 == 0} {
	   set err 1
	   set errstr  $error(even)
    }

    if {$err} {

	    # "          (err)"
	    set output [format "%*s%s" 10 "" "$errstr"]

    } else {

	    # split into list of each letter
	    set letters [split $num ""]

	    # middle of list
	    set mid  [expr {$dlen / 2}]

	    # get 3 in the middle
	    set a [lindex $letters [expr {$mid-1} ] ]
	    set b [lindex $letters [expr {$mid}   ] ]
	    set c [lindex $letters [expr {$mid+1} ] ]

	    # "          123"
	    set output [format "%*s%d" 10 "" "$a$b$c"]
    }

    return  $output
}



# start here

puts stdout "test good list:\n"
puts stdout "${good}"

foreach num $good {
   set n  [middle_3 $num ]
   puts stdout "$num:\t$n"
}

puts ""
puts stdout "test bad list:\n"
puts stdout "${bad}"

foreach num $bad {
   set n  [middle_3 $num ]

   puts stdout "$num:\t$n"
}

#!/usr/bin/env  tclsh

# table/count of size categories
# (numbers are both strings and numbers)
# ''sizes(100)'' is the array member ''sizes("100")''

array set sizes {
    0           0
    100         0
    1000        0
    10000       0
    100000      0
    1000000     0
    10000000    0
    100000000   0
    1000000000  0
}

# sorted list of keys
set keys [lsort -integer [array names sizes]]

# check size and update count
proc count {f} {
    variable sizes
    variable keys

    #size in bytes of file
    set size  [file size $f]

    # increment count
    foreach { v }  $keys {
	    if {$size <= $v} {incr sizes($v) ; break}	
    }	
}

#recursive file name glob
proc getfiles {f} {

    if { [file isfile $f] } {

    # function call
	count $f
    } elseif { [file isdirectory $f] } {

	    set files [glob -nocomplain [file join $f *]]
		
         # recursive call
	    foreach d $files { getfiles $d }

    } else {
	    return
    }
}


# main
if { [info script] eq $::argv0 } {

    if { $::argc eq 0 } {
   	    puts stderr "need a dir to start searching"
	    return 1
    }

    foreach dir $::argv {
	    getfiles $dir

	    foreach v $keys {
	       puts "$v :  \t$sizes($v)"
	    }
    }

    return 0
}

# end

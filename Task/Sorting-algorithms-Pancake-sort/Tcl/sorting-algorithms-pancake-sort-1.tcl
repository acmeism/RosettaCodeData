package require Tcl 8.5
# Some simple helper procedures
proc flip {nlist n} {
    concat [lreverse [lrange $nlist 0 $n]] [lrange $nlist $n+1 end]
}
proc findmax {nlist limit} {
    lsearch -exact $nlist [tcl::mathfunc::max {*}[lrange $nlist 0 $limit]]
}

# Simple-minded pancake sort algorithm
proc pancakeSort {nlist {debug ""}} {
    for {set i [llength $nlist]} {[incr i -1] > 0} {} {
	set j [findmax $nlist $i]
	if {$i != $j} {
	    if {$j} {
		set nlist [flip $nlist $j]
		if {$debug eq "debug"} {puts [incr flips]>>$nlist}
	    }
	    set nlist [flip $nlist $i]
	    if {$debug eq "debug"} {puts [incr flips]>>$nlist}
	}
    }
    return $nlist
}

package require Tcl 8.5
proc topsort {data} {
    # Clean the data
    dict for {node depends} $data {
	if {[set i [lsearch -exact $depends $node]] >= 0} {
	    set depends [lreplace $depends $i $i]
	    dict set data $node $depends
	}
	foreach node $depends {dict lappend data $node}
    }
    # Do the sort
    set sorted {}
    while 1 {
	# Find available nodes
	set avail [dict keys [dict filter $data value {}]]
	if {![llength $avail]} {
	    if {[dict size $data]} {
		error "graph is cyclic, possibly involving nodes \"[dict keys $data]\""
	    }
	    return $sorted
	}
	# Note that the lsort is only necessary for making the results more like other langs
	lappend sorted {*}[lsort $avail]
        # Remove from working copy of graph
	dict for {node depends} $data {
	    foreach n $avail {
		if {[set i [lsearch -exact $depends $n]] >= 0} {
		    set depends [lreplace $depends $i $i]
		    dict set data $node $depends
		}
	    }
	}
	foreach node $avail {
	    dict unset data $node
	}
    }
}

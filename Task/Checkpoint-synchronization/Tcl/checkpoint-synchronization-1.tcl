package require Tcl 8.5
package require Thread

namespace eval checkpoint {
    namespace export {[a-z]*}
    namespace ensemble create
    variable members {}
    variable waiting {}
    variable event
    # Back-end of join operation
    proc Join {id} {
	variable members
	variable counter
	if {$id ni $members} {
	    lappend members $id
	}
	return $id
    }
    # Back-end of leave operation
    proc Leave {id} {
	variable members
	set idx [lsearch -exact $members $id]
	if {$idx > -1} {
	    set members [lreplace $members $idx $idx]
	    variable event
	    if {![info exists event]} {
		set event [after idle ::checkpoint::Release]
	    }
	}
	return
    }
    # Back-end of deliver operation
    proc Deliver {id} {
	variable waiting
	lappend waiting $id

	variable event
	if {![info exists event]} {
	    set event [after idle ::checkpoint::Release]
	}
	return
    }
    # Releasing is done as an "idle" action to prevent deadlocks
    proc Release {} {
	variable members
	variable waiting
	variable event
	unset event
	if {[llength $members] != [llength $waiting]} return
	set w $waiting
	set waiting {}
	foreach id $w {
	    thread::send -async $id {incr ::checkpoint::Delivered}
	}
    }

    # Make a thread and attach it to the public API of the checkpoint
    proc makeThread {{script ""}} {
	set id [thread::create thread::wait]
	thread::send $id {
	    namespace eval checkpoint {
		namespace export {[a-z]*}
		namespace ensemble create

		# Call to actually join the checkpoint group
		proc join {} {
		    variable checkpoint
		    thread::send $checkpoint [list \
			    ::checkpoint::Join [thread::id]]
		}
		# Call to actually leave the checkpoint group
		proc leave {} {
		    variable checkpoint
		    thread::send $checkpoint [list \
			    ::checkpoint::Leave [thread::id]]
		}
		# Call to wait for checkpoint synchronization
		proc deliver {} {
		    variable checkpoint
		    # Do this from within the [vwait] to ensure that we're already waiting
		    after 0 [list thread::send $checkpoint [list \
			    ::checkpoint::Deliver [thread::id]]]
		    vwait ::checkpoint::Delivered
		}
	    }
	}
	thread::send $id [list set ::checkpoint::checkpoint [thread::id]]
	thread::send $id $script
	return $id
    }

    # Utility to help determine whether the checkpoint is in use
    proc anyJoined {} {
	variable members
	expr {[llength $members] > 0}
    }
}

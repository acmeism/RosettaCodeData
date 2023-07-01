# Build the workers
foreach worker {A B C D} {
    dict set ids $worker [checkpoint makeThread {
	proc task {name} {
	    checkpoint join
	    set deadline [expr {[clock seconds] + 2}]
	    while {[clock seconds] <= $deadline} {
		puts "$name is working"
		after [expr {int(500 * rand())}]
		puts "$name is ready"
		checkpoint deliver
	    }
	    checkpoint leave
	    thread::release; # Ask the thread to finish
	}
    }]
}

# Set them all processing in the background
dict for {name id} $ids {
    thread::send -async $id "task $name"
}

# Wait until all tasks are done (i.e., they have unregistered)
while 1 {
    after 100 set s 1; vwait s; # Process events for 100ms
    if {![checkpoint anyJoined]} {
	break
    }
}

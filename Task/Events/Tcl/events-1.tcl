# Simple task framework built from coroutines
proc pause ms {
    after $ms [info coroutine];yield
}
proc task {name script} {
    coroutine $name apply [list {} \
        "set ::tasks(\[info coro]) 1;$script;unset ::tasks(\[info coro])"]
}
proc waitForTasksToFinish {} {
    global tasks
    while {[array size tasks]} {
	vwait tasks
    }
}

# Make an Ada-like event class
oo::class create Event {
    variable waiting fired
    constructor {} {
	set waiting {}
	set fired 0
    }
    method wait {} {
	while {!$fired} {
	    lappend waiting [info coroutine]
	    yield
	}
    }
    method signal {} {
	set wake $waiting
	set waiting {}
	set fired 1
	foreach task $wake {
	    $task
	}
    }
    method reset {} {
	set fired 0
    }
}

# Execute the example
Event create X
task A {
    puts "waiting for event"
    X wait
    puts "received event"
}
task B {
    pause 1000
    puts "signalling X"
    X signal
}
waitForTasksToFinish

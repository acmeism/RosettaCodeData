package require x11

# With a display connection open, create and map a window
x display {
    set w [x window new 10 10 100 100 KeyPress]
    $w map

    x eventloop ev {
	expose {
	    # Paint the window
	    $w fill 20 20 10 10
	    $w text 10 50 "Hello, World!"
	}
	key {
	    # Quit the event loop
	    break
	}
    }

    $w destroy
}

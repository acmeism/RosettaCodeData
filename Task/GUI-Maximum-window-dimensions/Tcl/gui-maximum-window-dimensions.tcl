package require Tk
proc maxSize {} {
    # Need a dummy window; max window can be changed by scripts
    set top .__defaultMaxSize__
    if {![winfo exists $top]} {
        toplevel $top
        wm withdraw $top
    }
    # Default max size of window is value we want
    return [wm maxsize $top]
}

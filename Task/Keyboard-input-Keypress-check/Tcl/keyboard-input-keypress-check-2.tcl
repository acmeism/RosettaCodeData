fileevent stdin readable GetChar
proc GetChar {} {
    set ch [read stdin 1]
    if {[eof stdin]} {
        exit
    }
    # Do something with $ch here
}

vwait forever; # run the event loop if necessary

proc main {} {
    global argv argc
    if {$argc != 2} {
        error "usage: [info script] serveraddress serverport"
    }
    connect {*}$argv
    vwait dummyVar
}

proc connect {addr port} {
    global sock
    set sock [socket $addr $port]
    fconfigure $sock -buffering line
    fileevent $sock readable getFromServer
    fileevent stdin readable sendToServer
}

proc getFromServer {} {
    global sock
    if {[gets $sock line] == -1} {
        puts "disconnected..."
        exit
    } else {
        puts $line
    }
}

proc sendToServer {} {
    global sock
    set msg [string trim [gets stdin]]
    if {[string length $msg] > 0} {
        puts $sock $msg
    }
}

main

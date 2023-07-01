proc main {} {
    global connections
    set connections [dict create]
    socket -server handleConnection 12345
    vwait dummyVar ;# enter the event loop
}

proc handleConnection {channel clientaddr clientport} {
    global connections
    dict set connections $channel address "$clientaddr:$clientport"
    fconfigure $channel -buffering line
    fileevent $channel readable [list handleMessage $channel]
}

proc handleMessage {channel} {
    global connections
    if {[gets $channel line] == -1} {
        disconnect $channel
    } else {
        if {[string index [string trimleft $line] 0] eq "/"} {
            set words [lassign [split [string trim $line]] command]
            handleCommand $command $words $channel
        } else {
            echo $line $channel
        }
    }
}

proc disconnect {channel} {
    global connections
    dict unset connections $channel
    fileevent $channel readable ""
    close $channel
}

proc handleCommand {command words channel} {
    global connections
    switch -exact -- [string tolower $command] {
        /nick {
            dict set connections $channel nick [lindex $words 0]
        }
        /quit {
            echo bye $channel
            disconnect $channel
        }
        default {
            puts $channel "\"$command\" not implemented"
        }
    }
}

proc echo {message senderchannel} {
    global connections
    foreach channel [dict keys $connections] {
        if {$channel ne $senderchannel} {
            set time [clock format [clock seconds] -format "%T"]
            set nick [dict get $connections $channel nick]
            puts $channel [format "\[%s\] %s: %s" $time $nick $message]
        }
    }
}

main

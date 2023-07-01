package require Thread
set pool [tpool::create -initcmd {
    proc delayPrint msg {
        after [expr int(1000*rand())]
        puts $msg
    }
}]
tpool::post -detached $pool [list delayPrint "Enjoy"]
tpool::post -detached $pool [list delayPrint "Rosetta"]
tpool::post -detached $pool [list delayPrint "Code"]
tpool::release $pool
after 1200 ;# Give threads time to do their work
exit

package require Tk
package require snack


# variables bound to GUI:
set filename "sample.wav"
set nreps    5
set delay    200
set decay    0.9


# initial snack objects:
snack::sound wav -load sample.wav
snack::sound mixed  ;# used by [run]
snack::sound out    ;# used by [mix]

snack::sound hush -rate [wav cget -rate] -channels [wav cget -channels]
hush length [wav length]


proc make_gui {} {
    grid [label .l0 -text "Filename:"] [button .b0 -textvariable ::filename -command choose_file] -sticky nsew
    grid [label .l1 -text "Repetitions"] [entry .e1 -textvariable ::nreps] -sticky nsew
    grid [label .l2 -text "Pause"] [entry .e2 -textvariable ::delay] -sticky nsew
    grid [label .l3 -text "Decay"] [entry .e3 -textvariable ::decay] -sticky nsew
    grid [frame .b] -   ;# "-" for colspan
    grid [
        button .b.run  -text "Play" -command {coroutine runner run}
    ] [
        button .b.mix  -text "Premix" -command {coroutine runner mix}
    ] [
        button .b.stop -text "Stop" -command stop -state disabled
    ] [
        button .b.exit -text "Exit" -command exit
    ] -sticky nsew
}

# snack wraps tk_getOpenFile with suitable options to load supported audio files
proc choose_file {} {
    global filename
    set fn [snack::getOpenFile -initialfile $filename]
    if {$fn eq ""} return
    wav read [set filename $fn]
}

# disable play and enable stop for the duration of $script
proc lock_play {script} {
    .b.run configure -state disabled
    .b.mix configure -state disabled
    .b.stop configure -state normal
    try {
        uplevel 1 $script
    } finally {
        .b.run configure -state normal
        .b.mix configure -state normal
        .b.stop configure -state disabled
    }
}

# play by starting each echo as a distinct sound
proc run {} {
    global nreps delay decay
    lock_play {
        mixed copy wav
        mixed play
        for {set i 1} {$i < $nreps} {incr i} {
            yieldto after $delay [list catch [info coroutine]]  ;# delay without blocking the event loop
                                                                ;# [catch] in case the coroutine has been killed
            mixed mix hush -prescaling $decay   ;# scale and mix with silence to fade
            mixed play
        }
    }
}

# play using snack::filter to create the echo
proc mix {} {
    global nreps delay decay
    lock_play {
        out copy wav
        set args {} ;# for snack::filter echo
        for {set i 1} {$i < $nreps} {incr i} {
            lappend args [expr {$delay * $i}] [expr {$decay ** $i}]
        }
        set filter [snack::filter echo 1 1 {*}$args]
        out filter $filter
        $filter destroy
        yieldto out play -command [info coroutine]  ;# return to this proc only when playback completed
    }
}

# stop playback
proc stop {} {
    lock_play {
        foreach s {wav mixed out} {
            $s stop     ;# stop all sounds that may be playing
            catch {rename runner {}}    ;# kill the coroutine if it exists
        }
    }
}

make_gui

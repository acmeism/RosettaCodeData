package require Tcl 8.5

# Allow override of device name
proc systemRandomInteger {{device "/dev/random"}} {
    set f [open $device "rb"]
    binary scan [read $f 4] "I" x
    close $f
    return $x
}

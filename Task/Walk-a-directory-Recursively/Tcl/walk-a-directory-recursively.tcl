proc walkin {fromDir pattern} {
    foreach fname [glob -nocomplain -directory $fromDir *] {
        if {[file isdirectory $fname]} {
            walkin $fname $pattern
        } elseif {[string match $pattern [file tail $fname]]} {
            puts [file normalize $fname]
        }
    }
}
# replace directory with something appropriate
walkin /home/user *.mp3

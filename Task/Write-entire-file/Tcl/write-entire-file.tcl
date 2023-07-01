proc writefile {filename data} {
    set fd [open $filename w]   ;# truncate if exists, else create
    try {
        puts -nonewline $fd $data
    } finally {
        close $fd
    }
}

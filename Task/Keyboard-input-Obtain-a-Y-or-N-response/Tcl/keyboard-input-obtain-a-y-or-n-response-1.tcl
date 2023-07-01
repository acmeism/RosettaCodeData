proc yesno {{message "Press Y or N to continue"}} {
    fconfigure stdin -blocking 0
    exec stty raw
    read stdin ; # flush
    puts -nonewline "${message}: "
    flush stdout
    while {![eof stdin]} {
        set c [string tolower [read stdin 1]]
        if {$c eq "y" || $c eq "n"} break
    }
    puts [string toupper $c]
    exec stty -raw
    fconfigure stdin -blocking 1
    return [expr {$c eq "y"}]
}

set yn [yesno "Do you like programming (Y/N)"]

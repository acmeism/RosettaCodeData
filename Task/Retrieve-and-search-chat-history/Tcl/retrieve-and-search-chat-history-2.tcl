#! /usr/bin/env jimsh
proc get url {
    if {![regexp {http://([a-z.]+)(:[0-9]+)?(/.*)} $url _ host port path]} {
        error "can't parse URL \"$url\""
    }
    if {$port eq {}} { set port 80 }
    set ch [socket stream $host:$port]
    puts -nonewline $ch "GET /$path HTTP/1.0\n\n"
    set content [read $ch]
    if {[regexp {^HTTP[^<]+<!Doctype HTML.*<Title>URL Not Found</Title>} \
                $content]} {
        error {log file not found}
    }
    close $ch
    return $content
}

proc grep {needle haystack} {
    lsearch -all \
            -inline \
            -glob \
            [split $haystack \n] \
            *[string map {* \\* ? \\? \\ \\\\ [ \\[ ] \\]} $needle]*
}

proc main argv {
    lassign $argv needle
    set urlTemplate http://tclers.tk/conferences/tcl/%Y-%m-%d.tcl
    set back 10
    set now [clock seconds]
    # Jim Tcl doesn't support time zones, so we add an extra day to account for
    # the possible difference between the local and the server time.
    for {set i -$back} {$i <= 1} {incr i} {
        set date [expr {$now + $i*60*60*24}]
        set url [clock format $date -format $urlTemplate]
        catch {
            set found [grep $needle [get $url]]
            if {$found ne {}} {
                puts $url\n------\n[join $found \n]\n------\n
            }
        }
    }
}

main $argv

#! /usr/bin/env tclsh
package require http

proc get url {
    set r [::http::geturl $url]
    set content [::http::data $r]
    ::http::cleanup $r
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
    for {set i -$back} {$i <= 0} {incr i} {
        set date [clock add $now $i days]
        set url [clock format $date \
                              -format $urlTemplate \
                              -timezone :Europe/Berlin]
        set found [grep $needle [get $url]]
        if {$found ne {}} {
            puts $url\n------\n[join $found \n]\n------\n
        }
    }
}

main $argv

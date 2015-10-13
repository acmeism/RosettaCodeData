set keymap {
    2 -> ABC
    3 -> DEF
    4 -> GHI
    5 -> JKL
    6 -> MNO
    7 -> PQRS
    8 -> TUV
    9 -> WXYZ
}

set url http://www.puzzlers.org/pub/wordlists/unixdict.txt

set report {
There are %1$s words in %2$s which can be represented by the digit key mapping.
They require %3$s digit combinations to represent them.
%4$s digit combinations represent Textonyms.

A %5$s-letter textonym which has %6$s combinations is %7$s:

  %8$s
}

package require http
proc geturl {url} {
    try {
        set tok [http::geturl $url]
        return [http::data $tok]
    } finally {
        http::cleanup $tok
    }
}

proc main {keymap url} {
    foreach {digit -> letters} $keymap {
        foreach l [split $letters ""] {
            dict set strmap $l $digit
        }
    }
    set doc [geturl $url]
    foreach word [split $doc \n] {
        if {![string is alpha -strict $word]} continue
        dict lappend words [string map $strmap [string toupper $word]] $word
    }

    set ncombos [dict size $words]
    set nwords 0
    set ntextos 0
    set nmax 0
    set dmax ""
    dict for {d ws} $words {
        puts [list $d $ws]
        set n [llength $ws]
        incr nwords $n
        if {$n > 1} {
            incr ntextos $n
        }
        if {$n >= $nmax && [string length $d] > [string length $dmax]} {
            set nmax $n
            set dmax $d
        }
    }
    set maxwords [dict get $words $dmax]
    set lenmax [llength $maxwords]
    format $::report $nwords $url $ncombos $ntextos $lenmax $nmax $dmax $maxwords
}

puts [main $keymap $url]

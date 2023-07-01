namespace eval shuffle {

    proc perfect {deck} {
        if {[llength $deck]%2} {
            return -code error "Deck must be of even length!"
        }
        set split [expr {[llength $deck]/2}]
        set top [lrange $deck 0 $split-1]
        set btm [lrange $deck $split end]
        foreach a $top b $btm {
            lappend res $a $b
        }
        return $res
    }

    proc cycle_length {transform deck} {
        set d $deck
        while 1 {
            set d [$transform $d]
            incr i
            if {$d eq $deck} {return $i}
        }
        return $i
    }

    proc range {a {b ""}} {
        if {$b eq ""} {
            set b $a; set a 0
        }
        set res {}
        while {$a < $b} {
            lappend res $a
            incr a
        }
        return $res
    }

}

set ::argv {}
package require tcltest
tcltest::test "Test perfect shuffle cycles" {} -body {
    lmap size {8 24 52 100 1020 1024 10000} {
        shuffle::cycle_length perfect [range $size]
    }
} -result {3 11 8 30 1018 10 300}

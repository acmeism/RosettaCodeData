namespace eval isin {
    proc _init {} {         ;# sets up the map used on every call
        variable map
        set alphabet abcdefghijklmnopqrstuvwxyz
        set n 9
        lmap c [split $alphabet ""] {
            lappend map $c [incr n]
        }
    }
    _init

    proc normalize {isin} {
        variable map
        string map $map [string tolower [string trim $isin]]
    }

    # copied from "Luhn test of credit card numbers"
    # included here for ease of testing, and because it is short
    proc luhn digitString {
        if {[regexp {[^0-9]} $digitString]} {error "not a number"}
        set sum 0
        set flip 1
        foreach ch [lreverse [split $digitString {}]] {
            incr sum [lindex {
                {0 1 2 3 4 5 6 7 8 9}
                {0 2 4 6 8 1 3 5 7 9}
            } [expr {[incr flip] & 1}] $ch]
        }
        return [expr {($sum % 10) == 0}]
    }

    proc validate {isin} {
        if {![regexp {^[A-Z]{2}[A-Z0-9]{9}[0-9]$} $isin]} {return false}
        luhn [normalize $isin]
    }

}

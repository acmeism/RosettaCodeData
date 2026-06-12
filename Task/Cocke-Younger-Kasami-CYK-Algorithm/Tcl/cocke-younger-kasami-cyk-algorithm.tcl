# rosettacode.org/wiki/Cocke-Younger-Kasami_(CYK)_Algorithm

# CYK parser implementation. Returns 1 if w is valid CYK under r rules.
proc cyk_parse {w r {startcode "NP"}} {
    set n [llength $w]

    # Initialize table t as a 2D array of sets (represented as dicts)
    for {set i 0} {$i < $n} {incr i} {
        for {set j 0} {$j < $n} {incr j} {
            set t($i,$j) [dict create]
        }
    }

    # Main CYK algorithm
    for {set j 0} {$j < $n} {incr j} {
        # Check for terminal rules
        dict for {lhs rules} $r {
            foreach rhs $rules {
                if {[llength $rhs] == 1 && [lindex $rhs 0] eq [lindex $w $j]} {
                    dict set t($j,$j) $lhs 1
                }
            }
        }

        # Check for non-terminal rules
        for {set i $j} {$i >= 0} {incr i -1} {
            for {set k $i} {$k < $j} {incr k} {
                dict for {lhs rules} $r {
                    foreach rhs $rules {
                        if {[llength $rhs] == 2} {
                            set rhs1 [lindex $rhs 0]
                            set rhs2 [lindex $rhs 1]
                            if {[dict exists $t($i,$k) $rhs1] &&
                                [dict exists $t([expr {$k+1}],$j) $rhs2]} {
                                dict set t($i,$j) $lhs 1
                            }
                        }
                    }
                }
            }
        }
    }

    return [dict exists $t(0,[expr {$n-1}]) $startcode]
}

# Test the CYK parser with a sample grammar and input string.
# start code: "NP"
# non_terminals: ["NP", "Nom", "Det", "AP", "Adv", "A"]
# terminals: ["book", "orange", "man", "tall", "heavy", "very", "muscular"]
proc testCYK {} {
    set r [dict create \
        "NP" [list [list "Det" "Nom"]] \
        "Nom" [list \
            [list "AP" "Nom"] \
            [list "book"] \
            [list "orange"] \
            [list "man"] \
        ] \
        "AP" [list \
            [list "Adv" "A"] \
            [list "heavy"] \
            [list "orange"] \
            [list "tall"] \
        ] \
        "Det" [list [list "a"]] \
        "Adv" [list [list "very"] [list "extremely"]] \
        "A" [list \
            [list "heavy"] \
            [list "orange"] \
            [list "tall"] \
            [list "muscular"] \
        ] \
    ]

    set w [split "a very heavy orange book"]
    return [cyk_parse $w $r "NP"]
}

puts "testCYK result: [testCYK]"

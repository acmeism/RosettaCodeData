proc de_bruijn {k n} {
    # de Bruijn sequence for alphabet k and subsequences of length n.
    if {[string is integer -strict $k]} {
        set alphabet {}
        for {set i 0} {$i < $k} {incr i} {
            lappend alphabet $i
        }
    } else {
        set alphabet $k
        set k [llength $alphabet]
    }

    set a [lrepeat [expr {$k * $n}] 0]
    set sequence {}

    proc db {a k n t p sequence_var} {
        upvar 1 $sequence_var sequence

        if {$t > $n} {
            if {$n % $p == 0} {
                set sequence [concat $sequence [lrange $a 1 [expr {$p}]]]
            }
        } else {
            lset a $t [lindex $a [expr {$t - $p}]]
            db $a $k $n [expr {$t + 1}] $p sequence
            for {set j [expr {[lindex $a [expr {$t - $p}]] + 1}]} {$j < $k} {incr j} {
                lset a $t $j
                db $a $k $n [expr {$t + 1}] $t sequence
            }
        }
    }

    db $a $k $n 1 1 sequence
    set result {}
    foreach i $sequence {
        append result [lindex $alphabet $i]
    }
    return $result
}

proc validate {db} {
    # Check that all combinations are present in De Bruijn string db.
    set dbwithwrap ${db}[string range $db 0 2]
    set digits {0 1 2 3 4 5 6 7 8 9}
    set errorstrings {}

    foreach d1 $digits {
        foreach d2 $digits {
            foreach d3 $digits {
                foreach d4 $digits {
                    set teststring ${d1}${d2}${d3}${d4}
                    if {[string first $teststring $dbwithwrap] == -1} {
                        lappend errorstrings $teststring
                    }
                }
            }
        }
    }

    set err_count [llength $errorstrings]
    if {$err_count > 0} {
        puts "  $err_count errors found:"
        foreach e $errorstrings {
            puts "    PIN number $e missing"
        }
    } else {
        puts "  No errors found"
    }
}

set db [de_bruijn 10 4]
puts ""
puts "The length of the de Bruijn sequence is [string length $db]"
puts ""
puts "The first 130 digits of the de Bruijn sequence are: [string range $db 0 129]"
puts ""
puts "The last 130 digits of the de Bruijn sequence are: [string range $db end-129 end]"
puts ""
puts "Validating the deBruijn sequence:"
validate $db

set dbreversed [string reverse $db]
puts ""
puts "Validating the reversed deBruijn sequence:"
validate $dbreversed

set dboverlaid [string range $db 0 4442].[string range $db 4444 end]
puts ""
puts "Validating the overlaid deBruijn sequence:"
validate $dboverlaid

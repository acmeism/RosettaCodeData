# some helpers for matrices in nice string form:
proc parse_matrix {s} {
    split [string trim $s] \n
}

proc print_matrix {m} {
    foreach row $m {
        puts [join [lmap x $row {format %3s $x}]]
    }
}

# obvious imperative version using [foreach]
proc kroenecker {A B} {
    foreach arow $A {
        foreach brow $B {
            set row {}
            foreach a $arow {
                foreach b $brow {
                    lappend row [expr {$a * $b}]
                }
            }
            lappend result $row
        }
    }
    return $result
}

proc lolcat {args} {    ;# see https://wiki.tcl.tk/41507
    concat {*}[uplevel 1 lmap $args]
}

# more compact but obtuse, using [lmap] and [lolcat]
proc kroenecker {A B} {
    lolcat arow $A {
        lmap brow $B {
            lolcat a $arow {
                lmap b $brow {
                    expr {$a * $b}
                }
            }
        }
    }
}

# demo:
set inputs {
    {1 2
     3 4}
    {0 5
     6 7}

    {0 1 0
     1 1 1
     0 1 0}
    {1 1 1 1
     1 0 0 1
     1 1 1 1}
}

foreach {a b} $inputs {
    set a [parse_matrix $a]
    set b [parse_matrix $b]
    print_matrix [kroenecker $a $b]
    puts ""
}

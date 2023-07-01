proc r_lcs {a b} {
    if {$a eq "" || $b eq ""} {return ""}
    set a_ [string range $a 1 end]
    set b_ [string range $b 1 end]
    if {[set c [string index $a 0]] eq [string index $b 0]} {
        return "$c[r_lcs $a_ $b_]"
    } else {
        set x [r_lcs $a $b_]
        set y [r_lcs $a_ $b]
        return [expr {[string length $x] > [string length $y] ? $x :$y}]
    }
}

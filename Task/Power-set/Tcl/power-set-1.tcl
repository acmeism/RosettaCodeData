proc subsets {l} {
    set res [list [list]]
    foreach e $l {
        foreach subset $res {lappend res [lappend subset $e]}
    }
    return $res
}
puts [subsets {a b c d}]

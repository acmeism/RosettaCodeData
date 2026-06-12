proc permutate {values size offset} {
    set count [llength $values]
    set arr [list]
    for {set i 0} {$i < $size} {incr i} {
        set selector [expr [round [expr $offset / [pow $count $i]]] % $count];
        lappend arr [lindex $values $selector]

    }
    return $arr
}

proc permutations {values size} {
    set a [list]
    set c [pow [llength $values] $size]
    for {set i 0} {$i < $c} {incr i} {
        set permutation [permutate $values $size $i]
        lappend a $permutation
    }
    return $a
}
# Usage
permutations [list 1 2 3 4] 3

package require struct::list
package require struct::set

proc foreachPermutation {varName listToPermute body} {
    upvar 1 $varName v
    set p [struct::list firstperm $listToPermute]
    for {} {$p ne ""} {set p [struct::list nextperm $p]} {
        set v $p; uplevel 1 $body
    }
}

proc findMissingCharPermutations {set} {
    set all {}
    foreachPermutation charPerm [split [lindex $set 0] {}] {
        lappend all [join $charPerm {}]
    }
    return [struct::set difference $all $set]
}

set have {
    ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC
    ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB
}
set missing [findMissingCharPermutations $have]

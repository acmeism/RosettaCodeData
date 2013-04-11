proc swap {aName bName} {
    upvar 1 $aName a $bName b
    lassign [list $a $b] b a
}

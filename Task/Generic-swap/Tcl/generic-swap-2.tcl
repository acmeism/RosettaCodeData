proc swap {aName bName} {
    upvar 1 $aName a $bName b
    foreach {b a} [list $a $b] break
}

proc swap {aName bName} {
    upvar 1 $aName a $bName b
    set a $b[set b $a; list]
}

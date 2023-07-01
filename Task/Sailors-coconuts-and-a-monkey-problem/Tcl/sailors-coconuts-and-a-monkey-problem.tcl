proc assert {expr {msg ""}} {    ;# for "static" assertions that throw nice errors
    if {![uplevel 1 [list expr $expr]]} {
        if {$msg eq ""} {
            catch {set msg "{[uplevel 1 [list subst -noc $expr]]}"}
        }
        throw {ASSERT ERROR} "{$expr} $msg"
    }
}

proc divmod {a b} {
    list [expr {$a / $b}] [expr {$a % $b}]
}

proc overnight {ns nn} {
    set result {}
    for {set s 0} {$s < $ns} {incr s} {
        lassign [divmod $nn $ns] q r
        assert {$r eq 1} "Incorrect remainder in round $s (expected 1, got $r)"
        set nn [expr {$q*($ns-1)}]
        lappend result $s $q $r $nn
    }
    lassign [divmod $nn $ns] q r
    assert {$r eq 0} "Incorrect remainder at end (expected 0, got $r)"
    return $result
}

proc minnuts {nsailors} {
    while 1 {
        incr nnuts
        try {
            set result [overnight $nsailors $nnuts]
        } on error {} {
            # continue
        } on ok {} {
            break
        }
    }
    puts "$nsailors: $nnuts"
    foreach {sailor takes gives leaves} $result {
        puts " Sailor #$sailor takes $takes, giving $gives to the monkey and leaves $leaves"
    }
    puts "In the morning, each sailor gets [expr {$leaves/$nsailors}] nuts"
}


foreach n {5 6} {
    puts "Solution with $n sailors:"
    minnuts $n
}

package require tcltest

tcltest::test isin-1 "Test isin validation" -body {
    foreach {isin ok} {
        US0378331005    yes
        US0373831005    no
        U50378331005    no
        US03378331005   no
        AU0000XVGZA3    yes
        AU0000VXGZA3    yes
        FR0000988040    yes
    } {
        if {$ok} {
            assert {[isin::validate $isin]}
        } else {
            assert {![isin::validate $isin]}
        }
    }
    return ok
} -result ok

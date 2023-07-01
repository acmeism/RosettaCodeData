## We use (regular) continued fractions, step by step.
## The partial CF is coded (a n b m) for (a+nr) / (b+mr) for rest r.
## The (current) approximation is a/b (for r=0)

proc cfExt {anbm u} {
    if {$u <= 0} {
        return $anbm
    }
    lassign $anbm a n b m

    set na [expr {($a * $u) + $n}]
    set nn $a
    set nb [expr {($b * $u) + $m}]
    set nm $b

    return [list $na $nn $nb $nm]
}

proc cfPrec {anbm} {
    lassign $anbm a n b m

    ## The next term will change about 1 / (b*m)
    return [expr {[string length $b$m] - 1}]
}

proc cfInt {k} {
    return [list $k 1 1 0]
}

proc calcE {decplaces} {
    ## cf for e is [2;1, 2,1,1, 4,1,1, 6,1,1, 8,1,1, ...]
    set ecf [cfInt 2]
    set ecf [cfExt $ecf 1]
    for {set j 2} {1} {incr j 2} {
        if {[cfPrec $ecf] >= $decplaces} {
            break
        }
        set ecf [cfExt $ecf $j]
        set ecf [cfExt $ecf 1]
        set ecf [cfExt $ecf 1]
    }
    lassign $ecf a n b m
    set q [expr {(10**$decplaces * $a) / $b}]
    puts "e = $a / $b  ([string range $q 0 0].[string range $q 1 end])"
    puts "e = [expr {(0.0 + $a) / $b}]"
}

calcE 17

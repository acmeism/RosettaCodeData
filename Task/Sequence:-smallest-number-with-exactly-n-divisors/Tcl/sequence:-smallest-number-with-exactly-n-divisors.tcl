proc divCount {n} {
    set cnt 0
    for {set d 1} {($d * $d) <= $n} {incr d} {
        if {0 == ($n % $d)} {
            incr cnt
            if {$d < ($n / $d)} {
                incr cnt
            }
        }
    }
    return $cnt
}

proc A005179 {n} {
    if {$n >= 1} {
        for {set k 1} {1} {incr k} {
            if {$n == [divCount $k]} {
                return $k
            }
        }
    }
    return 0
}

proc show {func lo hi} {
    puts "${func}($lo..$hi) ="
    for {set n $lo} {$n <= $hi} {incr n} {
        puts -nonewline " [$func $n]"
    }
    puts ""
}

show A005179 1 15

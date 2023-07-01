proc lincom {factors} {
    set exp 0
    set res ""
    foreach f $factors {
        incr exp
        if {$f == 0} {
            continue
        } elseif {$f == 1} {
            append res "+e($exp)"
        } elseif {$f == -1} {
            append res "-e($exp)"
        } elseif {$f > 0} {
            append res "+$f*e($exp)"
        } else {
            append res "$f*e($exp)"
        }
    }
    if {$res eq ""} {set res 0}
    regsub {^\+} $res {} res
    return $res
}

foreach test {
    {1 2 3}
    {0 1 2 3}
    {1 0 3 4}
    {1 2 0}
    {0 0 0}
    {0}
    {1 1 1}
    {-1 -1 -1}
    {-1 -2 0 -3}
    {-1}
} {
    puts [format "%10s -> %-10s" $test [lincom $test]]
}

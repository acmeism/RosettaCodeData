proc S2 {n k} {
    set nk [list $n $k]
    if {[info exists ::S2cache($nk)]} {
        return      $::S2cache($nk)
    }
    if {($n > 0 && $k == 0) || ($n == 0 && $k > 0)} {
        return 0
    }
    if {$n == $k} {
        return 1
    }
    if {$n < $k} {
        return 0
    }
    set n1 [expr {$n - 1}]
    set k1 [expr {$k - 1}]
    set r  [expr {($k * [S2 $n1 $k]) + [S2 $n1 $k1]}]
    set ::S2cache($nk) $r
}

proc main {} {
    puts "Stirling numbers of the second kind:"
    set max 12                  ;# last table line to print
    set L   8                   ;# space to use for 1 number
    puts -nonewline "n\\k"
    for {set n 0} {$n <= $max} {incr n} {
        puts -nonewline [format %${L}d $n]
    }
    puts ""
    for {set n 0} {$n <= $max} {incr n} {
        puts -nonewline [format %-3d $n]
        for {set k 0} {$k <= $n} {incr k} {
            puts -nonewline [format %${L}s [S2 $n $k]]
        }
        puts ""
    }
    puts "The maximum value of S2(100, k) = "
    set previous 0
    for {set k 1} {$k <= 100} {incr k} {
        set current [S2 100 $k]
        if {$current > $previous} {
            set previous $current
        } else {
            puts $previous
            puts "([string length $previous] digits, k = [expr {$k-1}])"
            break
        }
    }
}
main

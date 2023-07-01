proc US1 {n k} {
    if {$k == 0} {
        return [expr {$n == 0}]
    }
    if {$n < $k} {
        return 0
    }
    if {$n == $k} {
        return 1
    }

    set nk [list $n $k]
    if {[info exists ::US1cache($nk)]} {
        return      $::US1cache($nk)
    }
    set n1 [expr {$n - 1}]
    set k1 [expr {$k - 1}]
    set r  [expr {($n1 * [US1 $n1 $k]) + [US1 $n1 $k1]}]

    set ::US1cache($nk) $r
}

proc main {} {
    puts "Unsigned Stirling numbers of the first kind:"
    set max 12                  ;# last table line to print
    set L   9                   ;# space to use for 1 number
    puts -nonewline "n\\k"
    for {set n 0} {$n <= $max} {incr n} {
        puts -nonewline " [format %${L}d $n]"
    }
    puts ""
    for {set n 0} {$n <= $max} {incr n} {
        puts -nonewline [format %-3d $n]
        for {set k 0} {$k <= $n} {incr k} {
            puts -nonewline " [format %${L}s [US1 $n $k]]"
        }
        puts ""
    }
    puts "The maximum value of US1(100, k) = "
    set previous 0
    for {set k 1} {$k <= 100} {incr k} {
        set current [US1 100 $k]
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

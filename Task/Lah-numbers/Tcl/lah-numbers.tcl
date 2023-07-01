proc prod {from to} {
    set r 1
    if {$from <= $to} {
        set r $from
        while {[incr from] <= $to} {
            set r [expr {$r * $from}]
        }
    }
    return $r
}

proc US3 {n k} {
    if {$n < 0 || $k < 0} {
        error "US3(): negative arg ($n,$k)"
    }
    ## L(0,0) = 1
    ## L(n,0) = 0       if 0 < n
    ## L(0,k) = 0       if 0 < k
    ## L(n,k) = 0       if n < k
    ## L(n,n) = 1
    if {$n == $k} {
        return 1
    }
    if {$n == 0 || $k == 0} {
        return 0
    }
    if {$n < $k} {
        return 0
    }

    set nk [list $n $k]
    if {[info exists ::US3cache($nk)]} {
        return      $::US3cache($nk)
    }
    if {$k == 1} {
        ## L(n,1) = n!
        set r [prod 2 $n]
    } else {
        ## k > 1
        ## L(n,k) = L(n,k-1) * (n - (k-1)) / ((k-1)*k)
        set k1 [expr {$k - 1}]
        set r  [expr {([US3 $n $k1] * ($n - $k1)) / ($k * $k1)}]
    }
    set ::US3cache($nk) $r
}

proc main {} {
    puts "Unsigned Lah numbers L(n,k):"
    set max  12                 ;# last n,k to print
    set L    10                 ;# space to use for 1 number
    set minn  1                 ;# first row to print
    set mink  1                 ;# first column to print
    puts -nonewline "n\\k"
    for {set n $minn} {$n <= $max} {incr n} {
        puts -nonewline " [format %${L}d $n]"
    }
    puts ""
    for {set n $minn} {$n <= $max} {incr n} {
        puts -nonewline [format %3d $n]
        for {set k $mink} {$k <= $n} {incr k} {
            puts -nonewline " [format %${L}s [US3 $n $k]]"
        }
        puts ""
    }
    set n 100
    puts "The maximum value of L($n, k) = "
    set maxv  0
    set maxk -1
    for {set k 0} {$k <= $n} {incr k} {
        set v [US3 $n $k]
        if {$v > $maxv} {
            set maxv $v
            set maxk $k
        }
    }
    puts $maxv
    puts "([string length $maxv] digits, k=$maxk)"
}
main

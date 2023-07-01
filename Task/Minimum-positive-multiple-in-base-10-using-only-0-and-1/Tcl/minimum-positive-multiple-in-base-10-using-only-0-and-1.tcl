package require Tcl 8.5

## power of ten, modulo --> (10**expo % modval)  suited for large expo
proc potmod {expo modval} {
    if {$expo   < 0} { return 0 }
    if {$modval < 2} { return 0 }               ;# x mod 1 = 0
    set r 1
    set p [expr {10 % $modval}]
    while {$expo} {
        set half [expr {$expo / 2}]
        set odd  [expr {$expo % 2}]
        if {$expo % 2} {
            set r [expr {($r * $p) % $modval}]          ;# r *= p
            if {$r == 0} break
        }
        set expo [expr {$expo / 2}]
        if {$expo} {
            set p [expr {($p * $p) % $modval}]          ;# p *= p
            if {$p == 1} break
        }
    }
    return $r
}

proc sho_sol {n r} {
    puts "B10([format %4s $n]) = [format %28s $r] = n * [expr {$r / $n}]"
}

proc do_1 {n} {
    if {$n < 2} {
        sho_sol $n 1
        return
    }
    set k 0                     ;# running exponent for powers of 10
    set potmn 1                 ;# (k-th) power of ten mod n
    set mvbyk($potmn) $k        ;# highest k for sum with mod value
    set canmv [list $potmn]     ;# which indices are in mvbyk(.)
    set solK -1                 ;# highest exponent of first solution

    for {incr k} {$k <= $n} {incr k} {
        ## By now we know what can be achieved below 10**k.
        ## Combine that with the new 10**k ...
        set potmn [expr {(10 * $potmn) % $n}]           ;# new power of 10
        if {$potmn == 0} {                              ;# found a solution
            set solK $k ; break
        }
        foreach mv $canmv {
            ## the mod value $mv can be constructed below $k
            set newmv [expr {($potmn + $mv) % $n}]
            ## ... and now we can also do $newmv.  Solution?
            if {$newmv == 0} {
                set solK $k ; break
            }
            if { ! [info exists mvbyk($newmv)] } {      ;# is new
                set mvbyk($newmv) $k    ;# remember highest expo
                lappend canmv $newmv
            }
        }
        if {$solK >= 0} { break }

        set newmv $potmn
        if { ! [info exists mvbyk($newmv)] } {
            set mvbyk($newmv) $k
            lappend canmv $newmv
        }
    }
    ## Reconstruct solution ...
    set k $solK
    set mv 0            ;# mod value of $k and below (it is the solution)
    set r "1"           ;# top result, including $k
    while 1 {
        ## 10**k is the current largest power of ten in the solution
        ## $r includes it, already, but $mv is not yet updated
        set mv [expr {($mv - [potmod $k $n]) % $n}]
        if {$mv == 0} {
            append r [string repeat "0" $k]
            break
        }
        set subk $mvbyk($mv)
        append r [string repeat "0" [expr {$k - $subk - 1}]] "1"
        set k $subk
    }
    sho_sol $n $r
}

proc do_range {lo hi} {
    for {set n $lo} {$n <= $hi} {incr n} {
        do_1 $n
    }
}

do_range  1  10
do_range 95 105
foreach n {297 576 594 891 909 999  1998 2079 2251 2277  2439 2997 4878} {
    do_1 $n
}

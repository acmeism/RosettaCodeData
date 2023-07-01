proc jaro {s1 s2} {
    set l1 [string length $s1]
    set l2 [string length $s2]
    set dmax [expr {max($l1, $l2)/2 - 1}]   ;# window size to scan for matches
    set m1 {}                               ;# match indices
    set m2 {}
    for {set i 0} {$i < $l1} {incr i} {
        set jmin [expr {$i - $dmax}]        ;# don't worry about going out-of-bounds
        set jmax [expr {$i + $dmax}]        ;# because [string index] will return {} safely
        for {set j $jmin} {$j <= $jmax} {incr j} {
            if {$j in $m2} continue   ;# don't double-count matches
            if {[string index $s1 $i] eq [string index $s2 $j]} {
                lappend m1 $i
                lappend m2 $j
                break
            }
        }
    }
    set T 0                 ;# number of transpositions
    set oj -1
    foreach j $m2 {
        if {$j < $oj} {incr T}
        set oj $j
    }
    set T [expr {$T / 2.0}]
    set M [expr {1.0 * [llength $m1]}]  ;# number of matches
    expr { ( ($M / $l1) + ($M / $l2) + (($M - $T) / $M) ) / 3.0 }
}


foreach {s t} {
    DWAYNE DUANE
    MARTHA MARHTA
    DIXON  DICKSONX
    JELLYFISH SMELLYFISH
} {
    puts "[jaro $s $t]:\t$s / $t"
}

proc isSquarefree {n} {
    for {set d 2} {($d * $d) <= $n} {set d [expr {($d+1)|1}]} {
        if {0 == ($n % $d)} {
            set n [expr {$n / $d}]
            if {0 == ($n % $d)} {
                return 0        ;# no, just found dup divisor
            }
        }
    }
    return 1                    ;# yes, no dup divisor found
}

proc unComma {str {comma ,}} {
    return [string map [list $comma {}] $str]
}

proc showRange {lo hi} {
    puts "Square-free integers in range $lo..$hi are:"
    set lo [unComma $lo]
    set hi [unComma $hi]
    set L  [string length $hi]
    set perLine 5
    while {($perLine * 2 * ($L+1)) <= 80} {
        set perLine [expr {$perLine * 2}]
    }
    set k 0
    for {set n $lo} {$n <= $hi} {incr n} {
        if {[isSquarefree $n]} {
            puts -nonewline " [format %${L}s $n]"
            incr k
            if {$k >= $perLine} {
                puts "" ; set k 0
            }
        }
    }
    if {$k > 0} {
        puts ""
    }
}

proc showCount {lo hi} {
    set rangtxt "$lo..$hi"
    set lo [unComma $lo]
    set hi [unComma $hi]
    set k 0
    for {set n $lo} {$n <= $hi} {incr n} {
        incr k [isSquarefree $n]
    }
    puts "Counting [format %6s $k] square-free integers in range $rangtxt"
}

showRange 1 145
showRange 1,000,000,000,000 1,000,000,000,145

foreach H {100 1000 10000 100000 1000000} {
    showCount 1 $H
}

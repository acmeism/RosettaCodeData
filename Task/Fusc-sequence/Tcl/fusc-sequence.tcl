proc fusc n {
    if {$n < 2} {
        return $n
    }

    if {[info exists ::g_fusc($n)]} { return $::g_fusc($n) }

    if {$n % 2} {               ;# n is odd
        set r [expr {[fusc [expr {($n-1)/2}]] + [fusc [expr {($n+1)/2}]]}]
    } else {                    ;# n is even
        set r [fusc [expr {$n/2}]]
    }

    if {$n < 999999} { set ::g_fusc($n) $r }

    return $r
}

proc ,,, {str {sep ,} {grouplen 3}} {
    set strlen [string length $str]
    set padlen [expr {($grouplen - ($strlen % $grouplen)) % $grouplen}]
    set r [regsub -all ... [string repeat " " $padlen]$str &$sep]
    return [string range $r $padlen end-[string length $sep]]
}

proc tabline {a b c} {
    puts "[format %2s $a] [format %10s $b] [format %8s $c]"
}

proc doit {{nmax 20000000}} {
    for {set i 0} {$i < 61} {incr i} {
        puts -nonewline " [fusc $i]"
    }
    puts ""
    tabline L n fusc(n)
    set maxL 0
    for {set n 0} {$n < $nmax} {incr n} {
        set f [fusc $n]
        set L [string length $f]
        if {$L > $maxL} {
            set maxL $L
            tabline $L [,,, $n] [,,, $f]
        }
    }
}
doit

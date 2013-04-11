primes::reset
foreach m {2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59} {
    set n [expr {2**$m - 1}]
    catch {time {set f [dict create {*}[primes::factors $n]]} 1} tm
    set primes [list]
    dict for {p e} $f {lappend primes {*}[lrepeat $e $p]}
    puts [format "2**%02d-1 = %-18s = %-22s => %s" $m $n [join $primes *] $tm]
}

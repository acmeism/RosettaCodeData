array set cache {}

set cache(0) 0

proc gcd {i j} {
   while {$j != 0} {
      set t [expr {$i % $j}]
      set i $j
      set j $t
   }
   return $i
}

proc is_perfect_totient {n} {
    global cache
    set tot 0
    for {set i 1} {$i < $n} {incr i} {
        if [ expr [gcd $i $n] == 1 ] {
            incr tot
        }
    }
    set sum [expr $tot + $cache($tot)]
    set cache($n) $sum
    return [ expr $n == $sum ? 1 : 0]
}

set i 1
set count 0
while { $count < 20 } {
    if [ is_perfect_totient $i ] {
        puts -nonewline  "${i} "
        incr count
    }
    incr i
}
puts ""

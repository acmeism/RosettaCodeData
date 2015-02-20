package require math::bigfloat
namespace import math::bigfloat::*

# Precision is an arbitrary value large enough to provide clear demonstration
proc hickerson {n {precision 28}} {
    set fac 1
    for {set i 1} {$i <= $n} {incr i} {set fac [expr {$fac * $i}]}
    set numerator [int2float $fac $precision]
    set 2 [int2float 2 $precision]
    set denominator [mul $2 [pow [log $2] [expr {$n + 1}]]]
    return [tostr -nosci [div $numerator $denominator]]
}

for {set n 1} {$n <= 17} {incr n} {
    set h [hickerson $n]
    set almost [regexp {\.[09]} $h]
    puts [format "h(%d) = %s (%salmost integer)" $n $h [expr {$almost ? "" : "not "}]]
}

proc digitReverse {n {base 2}} {
    set n [expr {[set neg [expr {$n < 0}]] ? -$n : $n}]
    set result 0.0
    set bit [expr {1.0 / $base}]
    for {} {$n > 0} {set n [expr {$n / $base}]} {
	set result [expr {$result + $bit * ($n % $base)}]
	set bit [expr {$bit / $base}]
    }
    return [expr {$neg ? -$result : $result}]
}

oo::class create SDAccum {
    variable sum sum2 num
    constructor {} {
        set sum 0.0
        set sum2 0.0
        set num 0
    }
    method value {x} {
        set sum2 [expr {$sum2 + $x**2}]
        set sum [expr {$sum + $x}]
        incr num
        return [my stddev]
    }
    method count {} {
        return $num
    }
    method mean {} {
        expr {$sum / $num}
    }
    method variance {} {
        expr {$sum2/$num - [my mean]**2}
    }
    method stddev {} {
        expr {sqrt([my variance])}
    }
}

# Demonstration
set sdacc [SDAccum new]
foreach val {2 4 4 4 5 5 7 9} {
    set sd [$sdacc value $val]
}
puts "the standard deviation is: $sd"

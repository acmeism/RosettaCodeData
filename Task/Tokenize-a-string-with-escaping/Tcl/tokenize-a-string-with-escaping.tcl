oo::class create tokens {
    constructor {s} {
        puts [coroutine Next my Iter $s]
        oo::objdefine [self] forward next Next
    }
    method Iter {s} {
        yield [info coroutine]
        for {set i 0} {$i < [string length $s]} {incr i} {
            yield [string index $s $i]
        }
        return -code break
    }
}

proc tokenize {s {sep |} {escape ^}} {
    set part ""
    set parts ""
    set iter [tokens new $s]
    while {1} {
        set c [$iter next]
        if {$c eq $escape} {
            append part [$iter next]
        } elseif {$c eq $sep} {
            lappend parts $part
            set part ""
        } else {
            append part $c
        }
    }
    lappend parts $part
    return $parts
}

puts [tokenize one^|uno||three^^^^|four^^^|^cuatro| | ^]

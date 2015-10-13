proc is_prime {n} {
    if {$n == 1} {return 0}
    if {$n in {2 3 5}} {return 1}
    for {set i 2} {$i*$i <= $n} {incr i} {
        if {$n % $i == 0} {return 0}
    }
    return 1
}

proc spiral {w h} {
    yield [info coroutine]
    set x [expr {$w / 2}]
    set y [expr {$h / 2}]
    set n 1
    set dir 0
    set steps 1
    set step 1
    while {1} {
        yield [list $x $y]
        switch $dir {
            0   {incr x}
            1   {incr y -1}
            2   {incr x -1}
            3   {incr y}
        }
        if {![incr step -1]} {
            set dir [expr {($dir+1)%4}]
            if {$dir % 2 == 0} {
                incr steps
            }
            set step $steps
        }
    }
}

set radius 16
set side  [expr {1 + 2 * $radius}]
set n     [expr {$side * $side}]
set cells [lrepeat $side [lrepeat $side ""]]
set i     1

coroutine spin spiral $side $side

while {$i < $n} {
    lassign [spin] y x
    set c [expr {[is_prime $i] ? "\u169b" : " "}]
    lset cells $x $y $c
    incr i
}

puts [join [lmap row $cells {join $row " "}] \n]

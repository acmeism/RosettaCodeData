# Task 1
proc harmonic {n} {
    if {$n < 1 || $n != [expr {floor($n)}]} {
        error "Argument to harmonic function is not a natural number"
    }
    set Hn 1
    for {set i 2} {$i <= $n} {incr i} {
        set Hn [expr {$Hn + (1.0/$i)}]
    }
    return $Hn
}

# Task 2
for {set x 1} {$x <= 20} {incr x} {
    set Hx [harmonic $x]
    puts "$x: $Hx"
}

# Task 3 /stretch
set x 0
set lastInt 1
while {$lastInt <= 10} {
    incr x
    set Hx [harmonic $x]
    if {$Hx > $lastInt} {
        puts -nonewline "The first harmonic number above $lastInt"
        puts " is $Hx at position $x"
        incr lastInt
    }
}

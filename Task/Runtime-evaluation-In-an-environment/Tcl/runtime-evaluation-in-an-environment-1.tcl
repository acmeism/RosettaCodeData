proc eval_twice {func a b} {
    set x $a
    set 1st [expr $func]
    set x $b
    set 2nd [expr $func]
    expr {$2nd - $1st}
}

puts [eval_twice {2 ** $x} 3 5] ;# ==> 24

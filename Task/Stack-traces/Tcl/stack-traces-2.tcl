proc outer {a b c} {
    middle [expr {$a+$b}] [expr {$b+$c}]
}
proc middle {x y} {
    inner [expr {$x*$y}]
}
proc inner k {
    printStackTrace
}
outer 2 3 5

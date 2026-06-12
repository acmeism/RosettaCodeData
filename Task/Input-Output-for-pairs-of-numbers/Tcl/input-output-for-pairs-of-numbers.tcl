gets stdin n
while {$n > 0} {
    if {[scan [gets stdin] "%d %d" a b] == 2} {
        puts [expr {$a + $b}]
    }
    incr n -1
}

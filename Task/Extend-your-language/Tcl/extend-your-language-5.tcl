proc timestables {M N} {
    loop i 1 $M {
        loop j 1 $N {
            puts "$i x $j = [expr {$i * $j}]"
        }
    }
}
timestables 3 3

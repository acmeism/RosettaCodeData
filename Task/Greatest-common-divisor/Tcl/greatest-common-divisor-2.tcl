proc gcd {p q} {
    if {$q == 0} {
        return $p
    }
    gcd $q [expr {$p % $q}]
}

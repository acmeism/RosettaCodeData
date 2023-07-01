proc gcd {p q} {
    if {$q == 0} {
        return $p
    }
    tailcall gcd $q [expr {$p % $q}]
}

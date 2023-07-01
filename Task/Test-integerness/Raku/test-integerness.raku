multi is-int ($n) { $n.narrow ~~ Int }

multi is-int ($n, :$tolerance!) {
    abs($n.round - $n) <= $tolerance
}

multi is-int (Complex $n, :$tolerance!) {
    is-int($n.re, :$tolerance) && abs($n.im) < $tolerance
}

# Testing:

for 25.000000, 24.999999, 25.000100, -2.1e120, -5e-2, Inf, NaN, 5.0+0.0i, 5-5i {
    printf "%-7s  %-9s  %-5s  %-5s\n", .^name, $_,
        is-int($_),
        is-int($_, :tolerance<0.00001>);
}
